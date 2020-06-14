class ShiftMailer < ApplicationMailer

	def shift_notification(shift)
    @shift = shift
    @user = shift.user
    logger.debug("Sending mail to #{@user.email} from #{ENV['NOREPLY']}")
    mail( :to => @user.email,
          :bcc => ENV['ADMIN_EMAIL'],
          :subject => "New Shift Available: #{@shift.staffing_request.hospital.name} @ #{@shift.staffing_request.start_date.to_s(:custom_datetime)} : Notification #{shift.notification_count + 1}" )
  end


  def shift_started(shift)
    @shift = shift
    @user = shift.user
    logger.debug("Sending mail to #{@user.email} from #{ENV['NOREPLY']}")
    mail( :to => @user.email,
          :bcc => ENV['ADMIN_EMAIL'],
          :cc => @shift.staffing_request.user.email,
          :subject => "Shift Started: #{@shift.start_date.to_s(:custom_datetime)} ")
  end


  def shift_completed(shift, user)
    @shift = shift    
    @user = user
    logger.debug("Sending mail to #{@user.email} from #{ENV['NOREPLY']}")
    mail( :to => @user.email,
          :bcc => ENV['ADMIN_EMAIL'],
          :subject => "Shift Completed: #{@shift.start_date.to_s(:custom_datetime)} - #{@shift.end_date.to_s(:custom_datetime)} ")
  end

  def shift_ended(shift)
    @shift = shift
    @user = shift.user
    logger.debug("Sending mail to #{@user.email} from #{ENV['NOREPLY']}")
    mail( :to => @user.email,
          :bcc => ENV['ADMIN_EMAIL'],
          :cc => @shift.staffing_request.user.email,
          :subject => "Shift Ended: #{shift.end_date.to_s(:custom_datetime)}" )
  end


  def shift_cancelled(shift)
    @shift = shift
    @user = shift.user
    logger.debug("Sending mail to #{@user.email} from #{ENV['NOREPLY']}")

    if (@shift.response_status == "Cancelled")
      # Notify only the shift user, Do NOT notify the staffing_request.user
      mail( :to => @user.email,
            :bcc => ENV['ADMIN_EMAIL'],
            :cc => @shift.staffing_request.user.email,
            :subject => "Shift Cancelled: #{@shift.user.first_name}: #{@shift.staffing_request.start_date.to_s(:custom_datetime)}" )
    else
      # Also notify the staffing_request.user
      mail( :to => @user.email,
            :bcc => ENV['ADMIN_EMAIL'],            
            :subject => "Shift #{@shift.response_status}: #{@shift.user.first_name}: #{@shift.staffing_request.start_date.to_s(:custom_datetime)}" )
    end
  end

  def shift_accepted(shift)
    @shift = shift
    @user = shift.user

    logger.debug("Sending mail to #{@user.email} from #{ENV['NOREPLY']}")
    
    mail( :to => @user.email, :bcc =>ENV['ADMIN_EMAIL'],
          :subject => "Shift Confirmed: #{shift.staffing_request.start_date.to_s(:custom_datetime)}" )
  end

  def no_shift_found(staffing_request)
    @staffing_request = staffing_request
    mail( :to => ENV['ADMIN_EMAIL'],
          :subject => "No shift found for request from #{staffing_request.hospital.name}" )

  end

  def shift_confirmation(shift)
    @shift = shift
    @user = shift.user
    logger.debug("Sending mail to #{@user.email} from #{ENV['NOREPLY']}")
    mail( :to => @user.email, 
          :bcc => ENV['ADMIN_EMAIL'],
          :subject => "Shift Reminder: #{@shift.staffing_request.hospital.name} @ #{shift.staffing_request.start_date.to_s(:custom_datetime)}" )
  end

  def send_codes_to_broadcast_group(shift)
    @shift = shift
    @user  = shift.user
    emails = @shift.staffing_request.user.email

    if(@shift.hospital.hospital_broadcast_group)
      emails += ",#{@shift.hospital.hospital_broadcast_group}"  
    end

    if @shift.hospital.sister_hospitals
      subject = "Shift Confirmed: #{shift.hospital.name}: #{shift.staffing_request.start_date.to_s(:custom_datetime)}: #{shift.user.first_name}: Start / End Codes"
    else
      subject = "Shift Confirmed: #{shift.staffing_request.start_date.to_s(:custom_datetime)}: #{shift.user.first_name}: Start / End Codes"
    end
    
    mail( :to => emails, 
          :bcc => ENV['ADMIN_EMAIL'],
          :subject => subject )

  end

end