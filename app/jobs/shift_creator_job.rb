class ShiftCreatorJob < BaseQueuedJob
  queue_as :default

  SHIFT_ACCEPT_WAIT_TIME = eval(ENV['SHIFT_ACCEPT_WAIT_TIME'])

  def book_shift(staffing_request)

    if ( (Time.now.hour > 22 || Time.now.hour < 8) && staffing_request.start_date > Time.now + 1.day && Rails.env != "test")
      # Its late in the night & nurses will not accept the request
      # The shift is only required tomorrow
      logger.debug "ShiftCreatorJob: Skipping shift creation for #{staffing_request.id} as its late in the night and the start time is tomorrow"
    else
      # Select a temp who can be assigned this shift
      selected_nurses = select_nurses(staffing_request)
      logger.debug "ShiftCreatorJob: selected_nurses = #{selected_nurses}"
      # If we find a suitable temp - create a shift
      if selected_nurses.present? 

        selected_nurses.each do |nurse|
          Shift.create_shift(nurse, staffing_request)
        end

        # This will create a job that will select the winning shift of all the 
        # wait listed ones. It will do so after an delay of SHIFT_ACCEPT_WAIT_TIME 
        # of the shifts being created        
        if staffing_request.staff_type == 'Temp'
          if Rails.env == "test"
            ShiftResponseJob.perform_later(staffing_request.id, "AcceptWaitListed")
          else
            ShiftResponseJob.set(wait: SHIFT_ACCEPT_WAIT_TIME).perform_later(staffing_request.id, "AcceptWaitListed")
          end
        end
        
      else
        logger.error "ShiftCreatorJob: No nurse found for Staffing Request #{staffing_request.id}, #{ap staffing_request.select_user_audit}"
        if(staffing_request.shift_status != "Not Found")
          ShiftMailer.no_shift_found(staffing_request).deliver
        end
        staffing_request.shift_status = "Not Found"
        staffing_request.broadcast_status = "Sent"
        staffing_request.save
      end
    end
  end

  def perform
    logger ||= Rails.logger
    begin
      # For each open request which has not yet been broadcasted
      StaffingRequest.current.open.not_manual_assignment.not_broadcasted.each do |staffing_request|                                                                                                                            
        begin
          book_shift(staffing_request)
        rescue Exception => e
          logger.error "ShiftCreatorJob: #{e.message}"
          ExceptionNotifier.notify_exception(e)
        end
      end

    rescue Exception => e
      logger.error "ShiftCreatorJob: #{e.message}"
      ExceptionNotifier.notify_exception(e)
    ensure
      # Run this again
      ShiftCreatorJob.set(wait: 1.minute).perform_later
    end
    return nil

  end

  ### Private Methods Follow ###
  # private
  def get_same_day_booking(user, staffing_request)

    # Check if this user has been assigned another request on the same day
    # For other requests, he should have "Accepted" shifts
    # If the start or end date of the response lies inside the start or end date of the request then its a same day booking
    # If the start date is before and the end date is after then also its a same day booking

    # response.start_date > request.start_date && response.start_date < request.end_date
    # response.end_date > request.start_date && response.end_date < request.end_date
    # response.start_date < request.start_date && response.end_date > request.end_date

    # The confusing part of this where clause is that shifts do not have start end dates
    # In the query below, in the where clause all start and end dates are the
    # staffing responses dates via its relationship to the staffing request

    same_day_bookings = user.shifts.not_rejected.not_cancelled.not_wait_listed.includes(:staffing_request)
    .where("(staffing_requests.start_date <= ? and staffing_requests.end_date >= ?)
      or (staffing_requests.start_date <= ? and staffing_requests.end_date >= ?)
      or (staffing_requests.start_date >= ? and staffing_requests.end_date <= ?)",
           staffing_request.start_date, staffing_request.start_date,
           staffing_request.end_date, staffing_request.end_date,
           staffing_request.start_date, staffing_request.end_date).references(:staffing_request)

    logger.debug "ShiftCreatorJob: same_day_bookings = #{same_day_bookings.length}"

    return same_day_bookings

  end


  # Select all the avail_part_times available to service this request
  # Returns a list of users who match 
  def select_nurses(staffing_request)

    staffing_request.select_user_audit = {}

    nurses = []
    if staffing_request.staff_type == "Temp"
      nurses = staffing_request.hospital.temp_nurses.verified
    elsif staffing_request.staff_type == "Perm"
      nurses = staffing_request.hospital.perm_nurses.verified
    end

    # Check if the care home has preferred care givers
    if staffing_request.preferred_nurse_id
      # Sometimes we need to route the request to a specific nurse first
      nurses = [staffing_request.preferred_nurse   ]
    end
    
    selected_nurses = []
    if(nurses)      
      # Check if any of the pref_care_givers can be assigned to the shift
      nurses.each do |nurse|
        assign = assign_user_to_shift?(staffing_request, nurse) 
        if(assign)
          Rails.logger.debug "ShiftCreatorJob: #{nurse.email}, Request #{staffing_request.id} selected preferred care giver"
          selected_nurses << nurse
        end
      end
    else
      staffing_request.select_user_audit[""]
    end

    return selected_nurses
  end

  def assign_user_to_shift?(staffing_request, user)

      audit = {}

      audit["email"] = user.email
      audit["user_id"] = user.id

      if staffing_request.preferred_nurse_id == user.id
        audit["preferred_nurse"] = "Yes"
        staffing_request.select_user_audit[user.last_name + " " + user.first_name] = audit
        return true
      end

      role_ok = (user.role == staffing_request.role && !user.specializations.grep(/#{staffing_request.speciality}/).empty?)
      audit["role_ok"] = role_ok ? "Yes" : "No"

      day_of_week = Date::ABBR_DAYNAMES[staffing_request.start_date.wday]
      if ! user.part_time_work_days.include?(day_of_week)
        day_of_week_ok = false
        audit["day_of_week_ok"] = "No. Cannot work on #{day_of_week}"
      end

      date_ok = true
      if staffing_request.start_date.on_weekday? 
        if staffing_request.night_shift_minutes > 0 && !user.work_weeknights 
          date_ok = false
          audit["date_ok"] = "No. Cannot work weeknights"
        end
        if staffing_request.day_shift_minutes > 0 && !user.work_weekdays 
          date_ok = false
          audit["date_ok"] = "No. Cannot work weekdays"
        end
      elsif staffing_request.start_date.on_weekend? 
        if staffing_request.night_shift_minutes > 0 && !user.work_weekend_nights 
          date_ok = false
          audit["date_ok"] = "No. Cannot work weekend nights"
        end
        if staffing_request.day_shift_minutes > 0 && !user.work_weekends 
          date_ok = false
          audit["date_ok"] = "No. Cannot work weekends"
        end
      end


      audit["pause_shifts"] = user.pause_shifts ? "Yes" : "No" 
      staffing_request.select_user_audit[user.last_name + " " + user.first_name] = audit

      if (!role_ok || !date_ok || user.pause_shifts)
        return false
      end
      

      Rails.logger.debug "ShiftCreatorJob: Checking user #{user.email} with request #{staffing_request.id}"

      # Get the shift bookings for this user on the same time as this req
      same_day_bookings = get_same_day_booking(user, staffing_request)
      Rails.logger.debug "ShiftCreatorJob: #{user.email}, Request #{staffing_request.id}, same_day_bookings = #{same_day_bookings.length}"
      audit["same_day_bookings"] = same_day_bookings.length > 0 ? "Yes" : "No"
      audit["same_day_bookings_shifts"] = same_day_bookings.collect(&:id).join(",") if same_day_bookings.length > 0 

      # Check if this user has already rejected this req - Not applicable as we now send the request to all users
      # rejected = user_rejected_request?(user, staffing_request)
      # Rails.logger.debug "ShiftCreatorJob: #{user.email}, Request #{staffing_request.id}, rejected = #{rejected}"
      # audit["user_rejected_request"] = rejected ? "Yes" : "No"
      
      # Check pref_commute_distance - not applicable as we now have hospital_nurse_mapping 
      # setup beforehand based on pref_commute_distance
      # commute_ok, diff = pref_commute_ok?(user, staffing_request)
      # Rails.logger.debug "ShiftCreatorJob: #{user.email}, Request #{staffing_request.id}, commute_ok = #{commute_ok}"
      # audit["commute_ok"] = commute_ok ? "Yes" : "No"
      # audit["extra_commute_distance"] =  diff if !commute_ok

      staffing_request.select_user_audit[user.last_name + " " + user.first_name] = audit

      if(same_day_bookings.length == 0)        
        audit["selected"] = true
        return true
      end

      audit["selected"] = false
      return false
  end
  
end
