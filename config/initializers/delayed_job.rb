Delayed::Worker.destroy_failed_jobs = false
#Delayed::Worker.sleep_delay = 60
Delayed::Worker.max_attempts = 3
Delayed::Worker.max_run_time = 5.minutes
Delayed::Worker.read_ahead = 10
Delayed::Worker.default_queue_name = 'default'
Delayed::Worker.raise_signal_exceptions = :term
Delayed::Worker.logger = Logger.new(File.join(Rails.root, 'log', 'delayed_job.log'))

# Chain delayed job's handle_failed_job method to do exception notification
Delayed::Worker.class_eval do
  def handle_failed_job_with_notification(job, error)
    handle_failed_job_without_notification(job, error)
    # rescue if ExceptionNotifier fails for some reason
    begin
      Rails.logger.debug "DelayedJob JobId #{job.id}, attempts = #{job.attempts}"
      ExceptionNotifier.notify_exception(error)  if job.attempts == Delayed::Worker.max_attempts
    rescue Exception => e
      Rails.logger.error "ExceptionNotifier failed: #{e.class.name}: #{e.message}"
      e.backtrace.each do |f|
        Rails.logger.error "  #{f}"
      end
      Rails.logger.flush
    end
  end
  alias_method_chain :handle_failed_job, :notification
end


unless Rails.env.development?
  module Delayed
    module Backend
      module ActiveRecord
        class Job
          class << self
            alias_method :reserve_original, :reserve
            def reserve(worker, max_run_time = Worker.max_run_time)
              previous_level = ::ActiveRecord::Base.logger.level
              ::ActiveRecord::Base.logger.level = Logger::WARN if previous_level < Logger::WARN
              value = reserve_original(worker, max_run_time)
              ::ActiveRecord::Base.logger.level = previous_level
              value
            end
          end
        end
      end
    end
  end
end