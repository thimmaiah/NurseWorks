SanitizeEmail::Config.configure do |config|
  config[:sanitized_to] =         'team@nurseworks.co.in'
  config[:sanitized_cc] =         'admin@nurseworks.co.in'
  # config[:sanitized_bcc] =        'bcc@sanitize_email.org'
  # run/call whatever logic should turn sanitize_email on and off in this Proc:
  config[:activation_proc] =      Proc.new { %w(development staging).include?(Rails.env) }
  #config[:use_actual_email_prepended_to_subject] = true         # or false
  #config[:use_actual_environment_prepended_to_subject] = true   # or false
  config[:use_actual_email_as_sanitized_user_name] = true       # or false
end
