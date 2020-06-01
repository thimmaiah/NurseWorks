# This job closes the open requests which have no responses and
# have crossed the auto deny in time threshold
class RequestCloseJob < ApplicationJob

  queue_as :default

  def perform(staffing_request_id)
    
    begin
      # cancel the request
      req = StaffingRequest.find(staffing_request_id)
      UserNotifierMailer.request_cancelled(req).deliver_now
      req.request_status = "Cancelled"
      req.save
      
    rescue Exception => e
      logger.error "Error in RequestCloseJob"
      logger.error e.backtrace
    ensure
    end
    return nil
  end



end
