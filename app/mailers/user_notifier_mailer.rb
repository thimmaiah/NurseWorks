class UserNotifierMailer < ApplicationMailer

  def reference_notification(reference)
    logger.debug("Sending mail to #{reference.email}")

    @user = reference.user
    
    @reference = reference

    if @reference.ref_type == "Character Reference"
      mail( :to => reference.email, :bcc => ENV['ADMIN_EMAIL'],
            :subject => "Reference Request for: #{@user.first_name} #{@user.last_name}",
            :template_name => "reference_character_notification" )
    else

      filename = "#{Rails.root}/public/Reference_Request_to_employer_V3.doc"
      attachments["ReferenceRequest.doc"] = {
        :encoding => 'base64',
        :content  => Base64.encode64(File.read(filename))
      }

      mail( :to => reference.email, :bcc => ENV['ADMIN_EMAIL'],
            :subject => "Reference Request for: #{@user.first_name} #{@user.last_name}", 
            :template_name => "reference_employment_notification")
    end
  end

  def delete_requested(user_id)
    @user = User.find(user_id)
    logger.debug("Sending mail to #{ENV['NOREPLY']}")
    mail( :to => ENV['ADMIN_EMAIL'],
          :subject => "User requested deletion of personal data: #{@user.first_name} #{@user.last_name}" )
  end

  def request_verification(user_doc_id)
    @user_doc = UserDoc.find(user_doc_id)
    logger.debug("Sending mail to #{ENV['ADMIN_EMAIL']} from #{ENV['NOREPLY']}")
    mail( :to => ENV['ADMIN_EMAIL'],
          :subject => 'Document Verification Required.' )
  end


  def doc_refresh_notification(user_doc)
    @user = user_doc.user
    @user_doc = user_doc
    logger.debug("Sending mail to #{@user.email} from #{ENV['NOREPLY']}")
    mail( :to => @user.email,
          :subject => "Please upload latest document: #{user_doc.doc_type}" )
  end

  def training_refresh_notification(training)
    @user = training.user
    @training = training
    logger.debug("Sending mail to #{@user.email} from #{ENV['NOREPLY']}")
    mail( :to => @user.email,
          :subject => "Training will expire: #{training.name}" )
  end

  def doc_not_available(user_doc_id)
    @user_doc = UserDoc.find(user_doc_id)
    @user = @user_doc.user
    logger.debug("Sending mail to #{ENV['NOREPLY']}")
    mail( :to => ENV['ADMIN_EMAIL'],
          :subject => "DBS not available for #{@user.first_name} #{@user.last_name}" )
  end

  def user_docs_uploaded(user)
    @user = user

    logger.debug("Sending mail to #{ENV['NOREPLY']}")
    mail( :to => ENV['ADMIN_EMAIL'],
          :subject => "#{@user.first_name} #{@user.last_name} has uploaded all docs" )
  end


  def staffing_request_created(staffing_request)
    @staffing_request = staffing_request
    email = ENV['ADMIN_EMAIL']
    logger.debug("Sending mail to #{email} from #{ENV['NOREPLY']}")

    subject = staffing_request.manual_assignment_flag ? "Manual assignment required: New request from #{staffing_request.hospital.name}" : "New request from #{staffing_request.hospital.name}"
    mail( :to => email,
          :subject => subject )

  end

  def claim_hospital(hospital_id, user_id)
    @hospital = Hospital.find(hospital_id)
    @user = User.find(user_id)
    if(@hospital && @user)
      logger.debug("Sending mail to #{ENV['ADMIN_EMAIL']} from #{ENV['NOREPLY']}")
      mail( :to => ENV['ADMIN_EMAIL'],
            :subject => 'Add Admin to Care Home' )
    end
  end

  def hospital_verified(hospital_id)
    
    @hospital = Hospital.find(hospital_id)
    @user = @hospital.users.first
    if(@hospital)
      logger.debug("Sending mail to #{@hospital.emails} from #{ENV['NOREPLY']}")
      mail( :to => @hospital.emails,
            :bcc => ENV['ADMIN_EMAIL'],
            :subject => 'Care Home Verified' )
    end
  end


  def request_cancelled(staffing_request)
    @staffing_request = staffing_request
    email = @staffing_request.user.email
    logger.debug("Sending mail to #{email} from #{ENV['NOREPLY']}")
    mail( :to => email, :bcc => ENV['ADMIN_EMAIL'] ,
          :subject => "Request Cancelled: #{@staffing_request.start_date.to_s(:custom_datetime)}" )

  end

end
