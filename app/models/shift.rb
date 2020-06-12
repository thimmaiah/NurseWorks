class Shift < ApplicationRecord

  include StartEndTimeHelper
  include SmsHelper
  include ConfirmHelper

  # Please see ShiftSubscriber class - all side effects are handled there
  include Wisper.model

  acts_as_paranoid
  has_paper_trail

  RESPONSE_STATUS = ["Accepted", "Wait Listed", "Rejected", "Pending", "Auto Rejected", "Closed", "Cancelled"]
  PAYMENT_STATUS = ["UnPaid", "Pending", "Paid"]
  CONFIRMATION_STATUS = ["Pending", "Confirmed"]

  validates_presence_of :hospital_id, :user_id, :staffing_request_id

  belongs_to :user
  belongs_to :staffing_request
  belongs_to :hospital
  has_one :payment
  has_many :ratings

  # The audit trail of how the price was computed
  serialize :pricing_audit, Hash


  scope :not_rejected, -> {where("response_status <> 'Rejected' and response_status <> 'Auto Rejected'")}
  scope :not_cancelled, -> {where("response_status <> 'Cancelled'")}
  scope :not_wait_listed, -> {where("response_status <> 'Wait Listed'")}
  scope :accepted, -> {where("response_status = 'Accepted'")}
  scope :wait_listed, -> {where("response_status = 'Wait Listed'")}
  scope :closed, -> {where("response_status = 'Closed'")}
  scope :accepted_or_closed, -> {where("response_status in ('Closed', 'Accepted')")}
  scope :pending, -> {where("response_status = 'Pending'")}
  scope :rejected, -> {where("response_status = 'Rejected'")}
  scope :auto_rejected, -> {where("response_status = 'Auto Rejected'")}
  scope :rejected_or_auto, -> {where("response_status = 'Rejected' or response_status = 'Auto Rejected'")}
  scope :cancelled, -> {where("response_status = 'Cancelled'")}
  scope :open, -> {where("response_status in ('Pending', 'Accepted')")}
  scope :manual, -> {where("manual_assignment = ?", true)}
  scope :not_manual, -> {where("(manual_assignment is NULL or manual_assignment = ?)", false)}

  
  before_create :set_defaults  
  before_save :update_dates  

  attr_accessor :closing_started
  attr_accessor :testing

  # Set by the request when it is cancelled/closed. 
  # see StaffingRequest.update_response_status && Shift.shift_cancelled
  attr_accessor :closed_by_parent_request

  def set_defaults
    self.confirm_sent_count = 0
    self.confirmed_count = 0
    self.notification_count = 0
    self.nurse_break_mins = 0 if self.nurse_break_mins == nil
    # update the request
    self.staffing_request.broadcast_status = "Sent"
    self.staffing_request.shift_status = "Found"
  end


  def self.create_shift(selected_user, staffing_request, 
                        preferred_care_giver_selected=false, 
                        manual_assignment=false)

    resp_status = (staffing_request.staff_type == 'Perm') ? 'Accepted' : 'Pending'

    # Create the shift
    shift = Shift.new(staffing_request_id: staffing_request.id,
                      user_id: selected_user.id,
                      hospital_id: staffing_request.hospital_id,
                      nurse_break_mins: staffing_request.nurse_break_mins,
                      response_status: resp_status,
                      preferred_care_giver_selected: preferred_care_giver_selected,
                      manual_assignment: manual_assignment)


    Shift.transaction do
      
      # Save this new shift
      shift.save!
      
      # Mark selcted user with the auto selected date as today
      selected_user.auto_selected_date = Time.now
      selected_user.save

      # And ensure the staffing request is updated      
      staffing_request.broadcast_status = "Sent"
      staffing_request.shift_status = "Found"      
      staffing_request.save
      
    end

    return shift
  

  end

  def update_response(response_status)
    if response_status == "Accepted"
      self.response_status = "Wait Listed"
    else
      self.response_status = "Rejected"
    end
    self.save
  end

  def update_dates
    # Sometimes admin have to manually close a shift, so they supply the start/end codes and dates
    if(!manual_close)
      if(self.start_code_changed?)
        self.start_date = Time.now
        self.start_date = self.start_date.change({sec: 0}) if self.start_date
        # ShiftMailer.shift_started(self).deliver_later
        # self.send_shift_started_sms(self)
      end
      if(self.end_code_changed?)
        # End Time cannot be < 4 hours from start time
        self.end_date = (Time.now - self.start_date)/ (60 * 60) > 4 ? Time.now : (self.start_date + 4.hours)
        self.end_date = self.end_date.change({sec: 0}) if self.end_date
        # ShiftMailer.shift_ended(self).deliver_later
        # self.send_shift_ended_sms(self)
      end
    end
  end

  def close_manually(start_date=nil, end_date=nil)

    logger.debug "close_manually #{self.id} #{start_date} #{end_date}"
    
    self.start_code = self.staffing_request.start_code
    self.end_code = self.staffing_request.end_code
    self.start_date = start_date.present? ? start_date : self.staffing_request.start_date
    self.end_date = end_date.present? ? end_date : self.staffing_request.end_date
    self.manual_close = true

    if(!self.end_code_changed?)
      # This shift is being manually closed for the 2nd time - so the close_shift has to be run manually.
      # Normally close shift runs in the shift_subcriber as a callback when the end_code changes
      ShiftCloseJob.perform_later(self.id)
      # This callback gets called multiple times - we want to do this only once. Hence closing_started
      self.closing_started = true
    end

    self.save


  end

  # Used to broadcast the shift n number of times on regular intervals
  def broadcast_shift_again
    max_count = ENV['MAX_SHIFT_NOTIFICATION_COUNT'].to_i
    max_time  = ENV["MAX_PENDING_SLOT_TIME_MINS"].to_i

    time_elapsed =  (Time.now - self.created_at)/60    
    self.notification_count ||= 0
    logger.debug "Brodcasting shift again: #{self.id}, time_elapsed = #{time_elapsed}, notification_count = #{self.notification_count}, #{max_time / max_count}"
    # If we've not sent out the max number of notifications & if the elapsed time is > the next notification time
    # If we have a 30 min MAX_PENDING_SLOT_TIME_MINS
    # And have a MAX_SHIFT_NOTIFICATION_COUNT of 3
    # Then we can send out a notification after every 10 mins 3 times
    if( self.notification_count < max_count && 
        time_elapsed > (max_time / max_count) * (self.notification_count + 1) )
      # Send out the notifications
      self.broadcast_shift
      self.notification_count += 1  
      return self.save
    end

    return false
  end

  

  def self.month_closed_shifts(date=Date.today)
    month_start = date.beginning_of_month
    month_end = date.end_of_month
    # Find all the users who had completed shifts in the prev months
    closed_shifts = Shift.joins(:staffing_request).where(response_status:"Closed").where("staffing_requests.start_date >= ? and staffing_requests.start_date < ?", month_start, month_end + 1.day)
    closed_shifts 
  end

  def create_payment
    Payment.new(shift_id: self.id, user_id: self.user_id, 
      hospital_id: self.hospital_id, paid_by_id: self.staffing_request.user_id,
      billing: self.hospital_base, amount: self.hospital_total_amount, 
      vat: self.vat, markup: self.markup, care_giver_amount: self.nurse_base,
      notes: "Thank you for your service.",
      staffing_request_id: self.staffing_request_id,
      created_at: self.end_date)    
  end

  def generate_anonymous_reject_hash
    Digest::SHA256.hexdigest self.id.to_s + ENV['SHIFT_REJECT_SECRET']
  end

end
