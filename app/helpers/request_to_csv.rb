class RequestToCSV


    def self.to_csv(care_home_ids, start_date, end_date)

	    shifts = Shift.accepted_or_closed.where(care_home_id: care_home_ids).includes(:care_home, :staffing_request)
	    shifts = shifts.where("shifts.start_date >= ? and shifts.end_date <= ?", start_date, end_date)
	    
	    attributes = 		%w{id start_date end_date response_status care_home_name booked_by carer day_hours night_hours care_home_total_amount}
	    core_attributes = 	%w{id start_date end_date response_status}

	    CSV.open("#{Rails.root}/tmp/shifts.csv", 'w', write_headers: true, headers: attributes) do |csv|
	      
	      shifts.each do |shift|
        	shift.day_mins_worked = 0 if shift.day_mins_worked == nil
        	shift.night_mins_worked = 0 if shift.night_mins_worked == nil

	        csv << [shift.id, shift.start_date, shift.end_date, shift.response_status, shift.care_home.name, 
	        		shift.staffing_request.user.first_name + " " + shift.staffing_request.user.last_name, 
	        		shift.user.first_name + " " + shift.user.first_name, 
        			shift.day_mins_worked / 60, shift.night_mins_worked / 60, shift.care_home_total_amount]
	        
	      end
	    end
	end


end