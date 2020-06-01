class ApplicationMailer < ActionMailer::Base
  
  default :from => ENV["NOREPLY"]
  layout 'mailer'
  
end
