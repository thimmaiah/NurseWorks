class ShiftCreatorJob < ApplicationJob
  queue_as :default

  def perform
    logger ||= Rails.logger

    begin
      # For each open request which has not yet been broadcasted
      StaffingRequest.current.open.not_manual_assignment.not_broadcasted.each do |staffing_request|
                                                                                                                            
        begin

          if ( (Time.now.hour > 22 || Time.now.hour < 8) && staffing_request.start_date > Time.now + 1.day && Rails.env != "test")
            # Its late in the night & carers will not accept the request
            # The shift is only required tomorrow
            logger.debug "Skipping shift creation for #{staffing_request.id} as its late in the night and the start time is tomorrow"
          else
            # Select a temp who can be assigned this shift
            selected_user, preferred_care_giver_selected = select_user(staffing_request)

            # If we find a suitable temp - create a shift
            if selected_user
              Shift.create_shift(selected_user, staffing_request, preferred_care_giver_selected)
            else
              logger.error "ShiftCreatorJob: No user found for Staffing Request #{staffing_request.id}"
              if(staffing_request.shift_status != "Not Found")
                ShiftMailer.no_shift_found(staffing_request).deliver
              end
              staffing_request.shift_status = "Not Found"
              staffing_request.broadcast_status = "Sent"
              staffing_request.save
            end

          end
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

  def self.add_to_queue
    if Delayed::Backend::ActiveRecord::Job.where("handler like '%ShiftCreatorJob%'").count == 0
      logger.info "ShiftCreatorJob: queued"
      ShiftCreatorJob.set(wait: 1.minute).perform_later
    else
      logger.info "ShiftCreatorJob: already queued. Nothing done"
    end
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

    same_day_bookings = user.shifts.not_rejected.not_cancelled.includes(:staffing_request)
    .where("(staffing_requests.start_date <= ? and staffing_requests.end_date >= ?)
      or (staffing_requests.start_date <= ? and staffing_requests.end_date >= ?)
      or (staffing_requests.start_date >= ? and staffing_requests.end_date <= ?)",
           staffing_request.start_date, staffing_request.start_date,
           staffing_request.end_date, staffing_request.end_date,
           staffing_request.start_date, staffing_request.end_date).references(:staffing_request)

    logger.debug "ShiftCreatorJob: same_day_bookings = #{same_day_bookings.length}"

    return same_day_bookings

  end

  # Check if this user has already rejected this request
  def user_rejected_request?(user, staffing_request)
    user.shifts.rejected_or_auto.where(staffing_request_id: staffing_request.id).length > 0
  end

  

  # UNUSED for now
  # If the request needs a generalist - any speciality can be used
  # Otherwise the speciality of the request must match the Nurse speciality
  def speciality_matches?(staffing_request, user)
    case staffing_request.speciality
    when "Generalist"
      return true
    else
      return staffing_request.speciality == user.speciality
    end
  end

  # UNUSED for now
  # The role required by the staffing_request must be the same as the user role
  # For nurses however we need to further match the speciality
  def matches_role_speciality?(staffing_request, user)

    if(staffing_request.role == user.role)
      case staffing_request.role
      when "Care Giver"
        return true
      when "Nurse"
        return speciality_matches?(staffing_request, user)
      end
    end

    return false

  end

  def pref_commute_ok?(user, staffing_request)
    begin
      travel_distance = user.distance_from(staffing_request.hospital)
      diff = (travel_distance - user.pref_commute_distance).round(1)
      ok = user.pref_commute_distance > travel_distance
      return ok, diff
    rescue Exception => e
      logger.error "ShiftCreatorJob: #{e.message} for staffing_request #{staffing_request.id} and user #{user.id}"
      logger.error e.backtrace
      ExceptionNotifier.notify_exception(e)
      return false, 0
    end
  end

  # Select a
  # 1 care giver
  # 2 who is verified
  # 3 who has not been selected before
  # 4 who has not been assigned on this date else where
  # 5 who has not rejected this request - perhaps because of another external engagement

  def select_user_old(staffing_request)

    staffing_request.select_user_audit = {}
    # Check if the care home has preferred care givers
    pref_care_givers = nil
    if staffing_request.preferred_carer_id
	    # Sometimes we need to route the request to a specific carer first
	    pref_care_givers = [staffing_request.preferred_carer]   
    else
    	pref_care_givers = staffing_request.preferred_care_givers
	  end
    
    if(pref_care_givers)      
      # Check if any of the pref_care_givers can be assigned to the shift
      pref_care_givers.each do |user|
        assign = assign_user_to_shift?(staffing_request, user)
        if(assign)
          Rails.logger.debug "ShiftCreatorJob: #{user.email}, Request #{staffing_request.id} selected preferred care giver"
          return user, true
        end
      end
    end

    if(staffing_request.preferred_carer_id == nil)
	    # If there are no pref carers, or if we dont want to limit to pref carers
	    if(pref_care_givers == nil || !staffing_request.limit_shift_to_pref_carer)
		    # If we cannot get a preferred_care_giver, then lets try everyone else if the care home allows it
		    # Change this to Geo search in 50 km radius of the care home. TODO
		    staffing_request.verified_users.where(role:staffing_request.role, speciality:staffing_request.speciality).active.order("auto_selected_date ASC").each do |user|
		      
		      assign = assign_user_to_shift?(staffing_request, user)
		      if(assign)
		        Rails.logger.debug "ShiftCreatorJob: #{user.email}, Request #{staffing_request.id} selected user"
		        return user, false
		      end
		    end
		end
	end

    return nil, false
  end

  def select_user(staffing_request)

    staffing_request.select_user_audit = {}
    # Check if the care home has preferred care givers
    hospital_carer_mappings = staffing_request.hospital.hospital_carer_mappings.enabled
    if staffing_request.preferred_carer_id
      # Sometimes we need to route the request to a specific carer first
      hospital_carer_mappings = hospital_carer_mappings.where(user_id: staffing_request.preferred_carer_id)   
    else
      # Randomize the list so we get even distribution across carers - but first try the preferred careres
      hospital_carer_mappings = hospital_carer_mappings.shuffle.sort_by{|ccm| ccm.preferred ? 0 : 1}
    end
    
    if(hospital_carer_mappings)      
      # Check if any of the pref_care_givers can be assigned to the shift
      hospital_carer_mappings.each do |ccm|
        user = ccm.user
        if (ccm.preferred || !staffing_request.limit_shift_to_pref_carer)
            assign = assign_user_to_shift?(staffing_request, user) 
            if(assign)
              Rails.logger.debug "ShiftCreatorJob: #{user.email}, Request #{staffing_request.id} selected preferred care giver"
              return user, true
            end
          end
      end
    end

    return nil, false
  end

  def assign_user_to_shift?(staffing_request, user)

      audit = {}

      audit["email"] = user.email

      role_ok = (user.role == staffing_request.role && user.speciality == staffing_request.speciality)
      audit["role_ok"] = role_ok ? "Yes" : "No"
      
      date_ok = true
      if staffing_request.start_date.on_weekday? 
        if staffing_request.night_shift_minutes > 0 && !user.work_weeknights 
          date_ok = false
          audit["date_ok"] = "Cannot work weeknights"
        end
        if staffing_request.day_shift_minutes > 0 && !user.work_weekdays 
          date_ok = false
          audit["date_ok"] = "Cannot work weekdays"
        end
      elsif staffing_request.start_date.on_weekend? 
        if staffing_request.night_shift_minutes > 0 && !user.work_weekend_nights 
          date_ok = false
          audit["date_ok"] = "Cannot work weekend nights"
        end
        if staffing_request.day_shift_minutes > 0 && !user.work_weekends 
          date_ok = false
          audit["date_ok"] = "Cannot work weekends"
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

      # Check if this user has already rejected this req
      rejected = user_rejected_request?(user, staffing_request)
      Rails.logger.debug "ShiftCreatorJob: #{user.email}, Request #{staffing_request.id}, rejected = #{rejected}"
      audit["user_rejected_request"] = rejected ? "Yes" : "No"
      
      # Check pref_commute_distance
      commute_ok, diff = pref_commute_ok?(user, staffing_request)
      Rails.logger.debug "ShiftCreatorJob: #{user.email}, Request #{staffing_request.id}, commute_ok = #{commute_ok}"
      audit["commute_ok"] = commute_ok ? "Yes" : "No"
      audit["extra_commute_distance"] =  diff if !commute_ok

      staffing_request.select_user_audit[user.last_name + " " + user.first_name] = audit

      if(same_day_bookings.length == 0 && !rejected && commute_ok)        
        audit["selected"] = true
        return true
      end

      audit["selected"] = false
      return false
  end
  
end
