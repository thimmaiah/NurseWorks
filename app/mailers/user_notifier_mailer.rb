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

    subject = staffing_request.manual_assignment_flag ? "Manual assignment required: New request from #{staffing_request.care_home.name}" : "New request from #{staffing_request.care_home.name}"
    mail( :to => email,
          :subject => subject )

  end

  def claim_care_home(care_home_id, user_id)
    @care_home = CareHome.find(care_home_id)
    @user = User.find(user_id)
    if(@care_home && @user)
      logger.debug("Sending mail to #{ENV['ADMIN_EMAIL']} from #{ENV['NOREPLY']}")
      mail( :to => ENV['ADMIN_EMAIL'],
            :subject => 'Add Admin to Care Home' )
    end
  end

  def care_home_verified(care_home_id)
    
    @care_home = CareHome.find(care_home_id)
    @user = @care_home.users.first
    if(@care_home)
      logger.debug("Sending mail to #{@care_home.emails} from #{ENV['NOREPLY']}")
      mail( :to => @care_home.emails,
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


  layout :select_layout


  def care_home_qr_code(care_home)

    require 'rqrcode'

    @care_home = care_home

    qrcode = RQRCode::QRCode.new(@care_home.qr_code)
    png = qrcode.as_png(
          resize_gte_to: false,
          resize_exactly_to: false,
          fill: 'white',
          color: 'black',
          size: 360,
          border_modules: 4,
          module_px_size: 6,
          file: nil # path to write
          )
    File.open("#{Rails.root}/public/system/#{@care_home.qr_code.to_s}.png", 'wb') {|file| file.write(png.to_s) }
    
    emails = @care_home.emails

    logger.debug("Sending mail to #{emails} from #{ENV['NOREPLY']}")
    mail( :to => emails,
          :subject => "Care Home QR Code: #{Date.today}" )
  
  end


  private
  def select_layout
    if action_name == 'care_home_qr_code'
      'qr_code'
    else
      'mailer'
    end
  end
end
