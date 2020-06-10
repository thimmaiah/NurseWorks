class BaseQueuedJob < ApplicationJob

    def self.add_to_queue(delay=1)
        if Delayed::Backend::ActiveRecord::Job.where("handler like '%#{name}%'").count == 0
            logger.info "#{name}: queued"
            "#{name}".constantize.set(wait: delay.minute).perform_later
        else
            logger.info "#{name}: already queued. Nothing done"
        end
    end
    
end