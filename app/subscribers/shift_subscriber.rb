class ShiftSubscriber

  def self.after_create(shift)  	
  	broadcast_shift(shift)
  end

  def self.after_commit(shift)

  	if shift.previous_changes.keys.include?("response_status")
  		if(shift.response_status == "Accepted")
        shift_accepted(shift)
      elsif(shift.response_status == "Closed")
        close_shift(shift)
      elsif(shift.response_status == "Cancelled")
        shift_cancelled(shift)
        # If this shift had been accepted and then cancelled, 
        # try to accept other wait listed shifts
        if self.staffing_request.request_status == "Open"
          ShiftResponseJob.perform_later(self.staffing_request_id, "AcceptWaitListed")
        end
  		elsif(["Rejected", "Auto Rejected"].include?(shift.response_status))
  			shift_cancelled(shift)
  		end
  	end
  end


  def self.broadcast_shift(shift)
    if(shift.response_status != 'Rejected' && shift.staffing_request.staff_type == 'Temp')
      Rails.logger.debug "ShiftSubscriber: Broadcasting shift #{shift.id}"
      PushNotificationJob.new.perform(shift)
      ShiftMailer.shift_notification(shift).deliver_later
      shift.send_shift_sms_notification(shift)
    end
  end


  def self.shift_cancelled(shift)
    if(["Rejected", "Auto Rejected", "Cancelled"].include?(shift.response_status))
      ShiftMailer.shift_cancelled(shift).deliver_later
      shift.send_shift_cancelled_sms(shift)
    end
  end

  def self.shift_accepted(shift)    

    if(shift.response_status == "Accepted")
    
      shift.user.total_accepted_shifts = shift.user.total_accepted_shifts + 1
      shift.user.weekly_accepted_shifts = shift.user.weekly_accepted_shifts + 1
      
      ShiftMailer.shift_accepted(shift).deliver_later
      shift.send_shift_accepted_sms(shift)
      # Send a mail to the broacast group with the start / end codes
      ShiftMailer.send_codes_to_broadcast_group(shift).deliver
    
    end
    
  end

  def self.close_shift(shift, force=false)
    # Ensure this gets priced
    if ( (!shift.closing_started && shift.nurse_base == nil) || force )

      ShiftCloseJob.perform_later(shift.id)
      # This callback gets called multiple times - we want to do this only once. Hence closing_started
      shift.closing_started = true

    end
  end



  
end