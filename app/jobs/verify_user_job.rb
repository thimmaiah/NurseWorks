class VerifyUserJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    # The user whose docs have been uploaded
    user = User.find(user_id)
    #Assume he is verified
    verified = false
    doc_count = 0
    # For each of the required docs - check if the doc is verified
    # The docs must not have expired or prev rejected
    user_docs = user.verifiable_docs


    if(user_docs.length == UserDoc::DOC_TYPES.length && !user.ready_for_verification)
      # Send a mail to ops that we need to manually verify this user as he has uploaded all docs
      logger.debug "VerifyUserJob: User #{user.id}, #{user.email} is ready_for_verification. Sending email to operations."
      UserNotifierMailer.user_docs_uploaded(user).deliver_now
      user.ready_for_verification = true
      user.save
    end

    user_docs.each do |doc|
      if( UserDoc::DOC_TYPES.include?(doc.doc_type) )
        logger.debug("VerifyUserJob: Verifying user #{user.id} doc #{doc.id} - #{doc.verified}")
        verified = verified && doc.verified
        doc_count += 1
      end
    end

    # Did we have all the required docs?
    if(doc_count == UserDoc::DOC_TYPES.length && user.phone_verified)

      verified = true

    end

    # Save the verified status
    logger.debug("VerifyUserJob: User #{user.id} verifiable_docs = #{user_docs.length}, phone_verified = #{user.phone_verified}, bank_account = #{user.bank_account}, sort_code = #{user.sort_code}")
    logger.debug("VerifyUserJob: User #{user.id} setting verified to #{verified}")
    user.verified = verified
    user.save


  end
end
