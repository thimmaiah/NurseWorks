class UnsubscribedInterceptor
  
  def self.delivering_email(message)
  	message.bcc = ENV['ADMIN_EMAIL']
  	user = User.find_by_email(message.to)
  	if(user && !user.subscription)
    	message.perform_deliveries = false
    	Rails.logger.info "Blocking mail for #{message.to} as user is unsubscribed"
    end
  end

end