# This job checks for all the shifts in "Wait Listed" state
# It then uses a fairness algorithm to pick a winner 
# It also ensure other WAIT_LIST shifts are cancelled, once a winner is picked
# Cancellation will only be done after a suitable time
class ShiftResponseJob < ApplicationJob

    queue_as :default
  
    def perform(staffing_request_id, type="AcceptWaitListed")
      
      if(type == "AcceptWaitListed")
        accept_wait_list(staffing_request_id)
      elsif(type == "CancelWaitListed")
        cancel_wait_list(staffing_request_id)
      else
        raise "Unknown type #{type}"
      end

      return nil

    end
  
    def accept_wait_list(staffing_request_id)
        begin
            # Get the request
            req = StaffingRequest.find(staffing_request_id)
            wait_listed_shifts = req.shifts.wait_listed.includes(:user).order("users.nq_score_normalized desc")
            # How do we faily allocate shifts ?
            # The higher NQ score should get more shifts, but others should not starve
            selected_shift = wait_listed_shifts.first
            if(selected_shift)
                logger.debug "Selected Shift #{selected_shift.id} for StaffingRequest #{req.id}"
                selected_shift.response_status = "Accepted"
                selected_shift.save
            else
                logger.debug "No Shifts found for StaffingRequest #{req.id}"
            end   
        rescue Exception => e
            logger.error "Error in ShiftResponseJob: accept_wait_list"
            logger.error e.backtrace
        end    
    end

    # This is called once the accepted shift has not been rejected for some time
    # And is used to cancel out the remaining wait listed shifts
    # as we have a potentially confirmed shift
    def cancel_wait_list(staffing_request_id)
        begin
            # Get the request
            req = StaffingRequest.find(staffing_request_id)
            wait_listed_shifts = req.shifts.wait_listed
            # Cancel all the wait listed shifts
            wait_listed_shifts.each do |shift|
                logger.debug "Cancelling wait listed Shift #{shift.id} for StaffingRequest #{req.id}"
                shift.response_status = "Cancelled"
                shift.save
            end   
        rescue Exception => e
            logger.error "Error in ShiftResponseJob: cancel_wait_list"
            logger.error e.backtrace
        end
    end
  end
  