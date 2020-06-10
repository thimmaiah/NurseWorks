class StaffingRequest < ApplicationRecord
  
  # Please see StaffingRequestSubscriber class - all side effects are handled there
  include Wisper.model
  include StartEndTimeHelper


  acts_as_paranoid
  has_paper_trail ignore: [:pricing_audit]

  after_save ThinkingSphinx::RealTime.callback_for(:staffing_request)

  REQ_STATUS = ["Open", "Closed", "Cancelled"]
  BROADCAST_STATUS =["Sent", "Failed"]
  SHIFT_STATUS =["Not Found", "Found"]

  belongs_to :hospital
  belongs_to :user
  has_many :shifts
  has_one :payment

  has_one :accepted_shift, -> { where(response_status:["Accepted", "Closed"]) }, :class_name => 'Shift' 
  has_one :assigned_shift, -> { where(response_status:["Accepted", "Closed", "Pending"]) }, :class_name => 'Shift' 

  belongs_to :recurring_request

  validates_presence_of :user_id, :hospital_id, :start_date, :shift_duration, :role
  validate :request_status_valid

  # The audit trail of how the price was computed
  serialize :pricing_audit, Hash
  serialize :select_user_audit, Hash


  scope :open, -> {where(request_status:"Open")}
  scope :not_found, -> {where(shift_status:"Not Found")}
  scope :closed, -> {where(request_status:"Closed")}
  scope :cancelled, -> {where(request_status:"Cancelled")}
  scope :not_cancelled, -> {where("request_status <> 'Cancelled'")}
  scope :not_broadcasted, -> {where("broadcast_status <> 'Sent'")}
  scope :current, -> {where("start_date >= ?", Time.now)}
  scope :not_manual_assignment, -> {where("manual_assignment_flag = ?", false)}
  scope :manual_assignment, -> {where("manual_assignment_flag = ?", true)}

  before_create :set_defaults, :price_estimate
  after_create :accept_shift_responses

  def set_defaults
    # We now have auto approval
    self.request_status = "Open"
    self.broadcast_status = "Pending"
    self.payment_status = "Unpaid"
    
    # Zero out the seconds - it causes lots of problems when calculating time spent
    self.start_date = self.start_date.change({sec: 0})
    self.end_date = self.start_date + self.shift_duration.hours

    # Copy over the manual_assignment_flag from the hospital
    self.manual_assignment_flag = self.hospital.manual_assignment_flag if self.manual_assignment_flag == nil 
    self.manual_assignment_flag = false if self.manual_assignment_flag == nil
  end


  def price_estimate
    # Ensure the request gets a price estimate before it is saved
    begin
      self.created_at = Time.now
      Rate.price_estimate(self) if self.staff_type == "Temp"
    rescue Exception => e  
      logger.error "Error in estimating price for request #{self.id} #{e.message}"
      ExceptionNotifier.notify_exception(e)
    end
  end

  # This will create a job that will select the winning shift of all the 
  # wait listed ones. It will do so after an hour of this request being created
  def accept_shift_responses
    ShiftResponseJob.set(wait: 1.hour).perform_later(self.id, "AcceptWaitListed")
  end


  def request_status_valid
    if( self.request_status_changed? )
      # Need to ensure that request whose shift has started cannot be cancelled.
      if(self.request_status == "Cancelled" && self.shifts.last && self.shifts.last.start_code != nil)
        errors.add(:request_status, "Cannot cancel request when the shift has started.")
      end
    end
  end

  def prev_versions
    self.versions.collect(&:reify)
  end

  def booking_start_diff_hrs
    (self.start_date - self.created_at)/(60 * 60)
  end

  def find_care_givers(max_kms_from_hospital, page)
    User.search   :with => {:role => self.role, :active=>true, :verified=>true, :geodist => 0.0..max_kms_from_hospital*1000.0}, 
                  :page=>page, :per_page=>10, 
                  :geo=>[self.hospital.lat * 0.01745329252, self.hospital.lng * 0.01745329252],
                  :order => "geodist ASC"

  end

  def preferred_nurse
    User.find(preferred_nurse_id) if preferred_nurse_id
  end

  def limit_shift_to_pref_nurse
    self.hospital.limit_shift_to_pref_nurse
  end
  
end
