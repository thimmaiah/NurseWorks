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

    # This returns the next to be selected for the shift among the waitlisted nurses
    # The input must be the list of waitlisted nurses who are sorted by nq_score_normalized
    def next_deserving_nurse(wait_listed_nurses)
        
        # Sort by nq_score_normalized
        wait_listed_nurses = wait_listed_nurses.sort {|n1, n2| n2.nq_score_normalized <=> n1.nq_score_normalized}
        # Get the sum of the nq_score_normalized & weekly_accepted_shifts_sum
        nq_score_normalized_sum = wait_listed_nurses.collect(&:nq_score_normalized).sum
        weekly_accepted_shifts_sum = wait_listed_nurses.collect(&:weekly_accepted_shifts).sum
        # This is to ensure no div by 0 error later
        weekly_accepted_shifts_sum = weekly_accepted_shifts_sum == 0 ? 1 : weekly_accepted_shifts_sum

        # See model https://docs.google.com/spreadsheets/d/1ZbPzCrSy2LXMBjQT5fiClFs-fbKDgy7YKJ3NwFotm4I/edit?usp=sharing
        wait_listed_nurses.each do |nurse|
            nq_score_pct = (nurse.nq_score * 1.0 / nq_score_normalized_sum) * 100
            weekly_accepted_shifts_pct = ((nurse.weekly_accepted_shifts + 1) * 1.0 / nurse.weekly_accepted_shifts) * 100 
            # If the following condition is true, then this nurse has not received 
            # shifts in proportion to her nq_score. Note the higher the score the more shifts 
            # she should get, but without starving others for shifts
            if weekly_accepted_shifts_pct < nq_score_pct
                return nurse
            end
        end

        # If we dont find anyone - then return the first nurse
        return wait_listed_nurses[0]

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
                selected_shift.save!
                # Ensure we cancel the other wait listed ones in 4 hours
                ShiftResponseJob.set(wait: 4.hour).perform_later(staffing_request_id, "CancelWaitListed")
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
  