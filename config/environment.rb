# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

Time::DATE_FORMATS[:custom_datetime] = "%d/%m/%Y  %H:%M"
Time::DATE_FORMATS[:custom_date] = "%d/%m/%Y"


ActionMailer::Base.register_interceptor(UnsubscribedInterceptor)

# ActionMailer::Base.smtp_settings = {
#   :user_name => ENV['SENDGRID_USER'],
#   :password => ENV['SENDGRID_PASS'],
#   :domain => 'nurseworks.co.in',
#   :address => 'smtp.sendgrid.net',
#   :port => 587,
#   :authentication => :plain,
#   :enable_starttls_auto => true
# }