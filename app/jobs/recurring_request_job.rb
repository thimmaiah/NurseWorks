class RecurringRequestJob < ApplicationJob
  queue_as :default

  def perform(rr_id)
  	Rails.logger.info "RecurringRequestJob: Start #{rr_id}"
    
    RecurringRequest.find(rr_id).create_for_dates
    
    Rails.logger.info "RecurringRequestJob: End"
  end
end
