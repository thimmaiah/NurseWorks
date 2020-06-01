class UserDocExpiryMailer < ApplicationMailer

	# send a signup email to the user, pass in the user object that   contains the user's email address
  def send_doc_expired_email(user_doc)
    @user = user_doc.user
    @user_doc = user_doc
    logger.debug("Sending mail to #{@user.email} from #{ENV['NOREPLY']}")
    mail( :to => @user.email,
          :subject => "Document expired: #{@user_doc.doc_type.titlecase}" )
  end

end
