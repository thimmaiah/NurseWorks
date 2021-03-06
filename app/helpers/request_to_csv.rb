class RequestToCSV


    def self.to_csv(hospital_ids, start_date, end_date)

	    shifts = Shift.accepted_or_closed.where(hospital_id: hospital_ids).includes(:hospital, :staffing_request)
	    shifts = shifts.where("shifts.start_date >= ? and shifts.end_date <= ?", start_date, end_date)
	    
	    attributes = 		%w{id start_date end_date response_status hospital_name booked_by nurse day_hours night_hours hospital_total_amount}
	    core_attributes = 	%w{id start_date end_date response_status}

	    CSV.open("#{Rails.root}/tmp/shifts.csv", 'w', write_headers: true, headers: attributes) do |csv|
	      
	      shifts.each do |shift|
        	shift.day_mins_worked = 0 if shift.day_mins_worked == nil
        	shift.night_mins_worked = 0 if shift.night_mins_worked == nil

	        csv << [shift.id, shift.start_date, shift.end_date, shift.response_status, shift.hospital.name, 
	        		shift.staffing_request.user.first_name + " " + shift.staffing_request.user.last_name, 
	        		shift.user.first_name + " " + shift.user.first_name, 
        			shift.day_mins_worked / 60, shift.night_mins_worked / 60, shift.hospital_total_amount]
	        
	      end
	    end
	end


end