class ShiftSubscriber

  def self.after_create(shift)  	
  	broadcast_shift(shift)
  end

  def self.after_commit(shift)

  	if shift.previous_changes.keys.include?("response_status")
  		if(shift.response_status == "Accepted")
  			shift_accepted(shift)
  		elsif(["Rejected", "Auto Rejected", "Cancelled"].include?(shift.response_status))
  			shift_cancelled(shift)
  		end
  	end

    if shift.previous_changes.keys.include?("end_code")
      if (shift.start_code == shift.staffing_request.start_code &&
          shift.end_code == shift.staffing_request.end_code)
        close_shift(shift)
      end
    end
    	
  end

  def self.broadcast_shift(shift)
    if(shift.response_status != 'Rejected')
      Rails.logger.debug "ShiftSubscriber: Broadcasting shift #{shift.id}"
      PushNotificationJob.new.perform(shift)
      ShiftMailer.shift_notification(shift).deliver_later
      shift.send_shift_sms_notification(shift)
    end
  end


  def self.shift_cancelled(shift)
    if(["Rejected", "Auto Rejected", "Cancelled"].include?(shift.response_status))

      if( !shift.closed_by_parent_request )
        # This was rejected - so ensure the request gets broadcasted again
        # If the broadcast_status is "Pending", the Notifier will pick it
        # up again in some time and send it out
        shift.staffing_request.broadcast_status = "Pending"
        shift.staffing_request.shift_status = nil
        shift.staffing_request.save
      end

      ShiftMailer.shift_cancelled(shift).deliver_later
      shift.send_shift_cancelled_sms(shift)
    end
  end

  def self.shift_accepted(shift)    
    if(shift.response_status == "Accepted")
    
      ShiftMailer.shift_accepted(shift).deliver_later
      shift.send_shift_accepted_sms(shift)
      # Send a mail to the broacast group with the start / end codes
      ShiftMailer.send_codes_to_broadcast_group(shift).deliver
    
    end
  end

  def self.close_shift(shift, force=false)
    # Ensure this gets priced, if we have the right star / end codes
    if ( (  !shift.closing_started && shift.carer_base == nil &&
            shift.start_code == shift.staffing_request.start_code &&
            shift.end_code == shift.staffing_request.end_code) || force )

      ShiftCloseJob.perform_later(shift.id)
      # This callback gets called multiple times - we want to do this only once. Hence closing_started
      shift.closing_started = true

    end
  end



  
end