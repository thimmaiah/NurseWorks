class ShiftConfirmJob < ApplicationJob
  queue_as :default

  def perform
  	Rails.logger.info "ShiftConfirmJob: Start"

    begin
      # Send confirmations for every accepted shift, which has not yet started, 
      # to ensure the care giver is going to show up
      Shift.joins(:staffing_request).accepted.where("staffing_requests.start_date > ?", Time.now).each do |shift|
      	
      	Rails.logger.info "ShiftConfirmJob: checking #{shift.id}"
      	if(shift.send_confirm?)
      		Rails.logger.info "ShiftConfirmJob: sending confirm for #{shift.id}"
      		# Send a mail asking the user to confirm
      		ShiftMailer.shift_confirmation(shift).deliver        
      		shift.confirmation_sent()
      	end
      	
      end

      Rails.logger.info "ShiftConfirmJob: End"
    rescue Exception => e      
      Rails.logger.error "ShiftConfirmJob: #{e.message}"
      ExceptionNotifier.notify_exception(e)
    ensure
      ShiftConfirmJob.set(wait: 15.minute).perform_later
    end
  end

  def self.add_to_queue
    if Delayed::Backend::ActiveRecord::Job.where("handler like '%ShiftConfirmJob%'").count == 0
      logger.info "ShiftConfirmJob: queued"
      ShiftConfirmJob.set(wait: 15.minute).perform_later
    else
      logger.info "ShiftConfirmJob: already queued. Nothing done"
    end
  end

end
