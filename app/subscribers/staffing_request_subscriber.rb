class StaffingRequestSubscriber

  def self.after_create(staffing_request)  	
  	UserNotifierMailer.staffing_request_created(staffing_request).deliver_later
  end

  def self.after_commit(staffing_request)
  	Rails.logger.debug "StaffingRequestSubscriber staffing_request.previous_changes = #{staffing_request.previous_changes}"
  	# Trigger only if request_status has changed
	if staffing_request.previous_changes.keys.include?("request_status")
			
		if( staffing_request.request_status == 'Closed' || staffing_request.request_status == 'Cancelled') 
			Rails.logger.debug "StaffingRequestSubscriber: closing all shifts for #{staffing_request.id}"
	
	        # Ensure all responses are also closed so they dont show up on the UI
	        staffing_request.shifts.open.each do |resp|
	          resp.response_status = staffing_request.request_status
	          resp.closed_by_parent_request = true
	          resp.save
	        end
	    end
	
	end
  end

end