source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'dotenv-rails', require: 'dotenv/rails-now'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.4.3'
# Use Puma as the app server
gem 'puma', '4.2.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

gem 'awesome_print'

# Use Capistrano for deployment
group :development do
    gem 'capistrano',         require: false
    gem 'capistrano-rvm',     require: false
    gem 'capistrano-rails',   require: false
    gem 'capistrano-bundler', require: false
    gem 'capistrano3-puma',   require: false
end

gem 'mysql2'
#gem 'jdbc-mysql',      '= 5.1.35', :platform => :jruby
gem 'thinking-sphinx'

gem 'oauth'
gem 'active_model_serializers'
gem 'rack-cors', :require => 'rack/cors'
gem 'cancancan'

gem 'rack-attack'
gem 'omniauth'
gem 'omniauth-rails_csrf_protection'

gem 'devise_token_auth'
gem "devise"

gem 'scout_apm'

# for background tasks
gem 'delayed_job'
gem 'delayed_job_active_record'
gem 'daemons'

gem "paperclip", ">= 5.2.0"

gem 'aws-sdk-s3'
gem 'faker'
gem "twilio-ruby"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'rspec-rails', '~> 3.5'
  gem 'bullet'
end

group :development do
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'letter_opener_web'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'factory_girl_rails'
gem 'exception_notification'

gem 'rest-client'
gem "administrate", "0.13.0"
gem 'ransack'
gem "paranoia", "~> 2.2"
gem "geocoder"
gem 'paper_trail'
gem 'sanitize_email'
gem 'responders'
gem 'whenever', :require => false
gem 'capybara-email'
# gem 'high_voltage'
gem 'roadie'
gem 'logstash-logger'

gem 'rubyzip', '>= 1.2.1'
gem 'axlsx', git: 'https://github.com/randym/axlsx.git', ref: 'c8ac844'
gem 'axlsx_rails'

gem 'rqrcode'

group :test do
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'selenium-webdriver'
  gem "webdrivers"
  gem 'formulaic'
end


gem 'rounding'
gem 'administrate-field-boolean_to_yes_no'
gem 'administrate-field-belongs_to_search'
gem 'jbuilder'
gem "actionview", ">= 5.0.7.2"

gem 'wisper'
gem 'wisper-activerecord'
# at the time of publishing the version of wiper-activejob in rubygems.org as quite old
gem 'wisper-activejob', github: 'krisleech/wisper-activejob'