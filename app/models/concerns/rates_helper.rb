module RatesHelper

  def nurse_amount(entity, rate, factor_name)
    total_mins = entity.minutes_worked 
    night_mins = entity.night_shift_minutes
    day_mins = total_mins - night_mins

    # Adjust the minutes worked by the unpaid break taken by the nurse 
    if(entity.nurse_break_mins > 0)
        if(entity.break_time.hour <= 8 || entity.break_time.hour >= 20) 
            # Break is in night time hours
            night_mins = night_mins - entity.nurse_break_mins
        else
            # Break is in day time hours
            day_mins = day_mins - entity.nurse_break_mins
        end 
    end

    day_time_hours_worked = entity.human_readable_time(day_mins.to_i)
    night_time_hours_worked = entity.human_readable_time(night_mins.to_i)

    logger.debug("total_mins = #{total_mins}, nurse_break_mins=#{entity.nurse_break_mins}, night_mins = #{night_mins}, day_mins = #{day_mins}, day_time_hours_worked = #{day_time_hours_worked}, night_time_hours_worked = #{night_time_hours_worked}")
    
    case factor_name
      when "DEFAULT_FACTOR"
        base = (day_mins * rate.nurse_weekday + night_mins * rate.nurse_weeknight) / 60
        calc_nurse_base = "#{day_time_hours_worked} x #{rate.nurse_weekday} + #{night_time_hours_worked} x #{rate.nurse_weeknight}"
      when "WEEKEND_FACTOR"
        base = (day_mins * rate.nurse_weekend + night_mins * rate.nurse_weekend_night) / 60
        calc_nurse_base = "#{day_time_hours_worked} x #{rate.nurse_weekend} + #{night_time_hours_worked} x #{rate.nurse_weekend_night}"
      when "BANK_HOLIDAY_FACTOR"
        base = (day_mins * rate.nurse_bank_holiday + night_mins * rate.nurse_bank_holiday) / 60
        calc_nurse_base = "#{day_time_hours_worked} x #{rate.nurse_bank_holiday} + #{night_time_hours_worked} x #{rate.nurse_bank_holiday}"
    end

    return base, day_mins, night_mins, calc_nurse_base

  end

  def hospital_amount(entity, rate, factor_name)
    total_mins = entity.minutes_worked 
    night_mins = entity.night_shift_minutes
    day_mins = total_mins - night_mins

    # Adjust the minutes worked by the unpaid break taken by the nurse 
    if(entity.nurse_break_mins > 0)
        if(entity.break_time.hour <= 8 || entity.break_time.hour >= 20) 
            # Break is in night time hours
            night_mins = night_mins - entity.nurse_break_mins
        else
            # Break is in day time hours
            day_mins = day_mins - entity.nurse_break_mins
        end 
    end

    day_time_hours_worked = entity.human_readable_time(day_mins.to_i)
    night_time_hours_worked = entity.human_readable_time(night_mins.to_i)

    logger.debug("total_mins = #{total_mins}, nurse_break_mins=#{entity.nurse_break_mins}, night_mins = #{night_mins}, day_mins = #{day_mins}, day_time_hours_worked = #{day_time_hours_worked}, night_time_hours_worked = #{night_time_hours_worked}")
    
    case factor_name
      when "DEFAULT_FACTOR"
        base = (day_mins * rate.hospital_weekday + night_mins * rate.hospital_weeknight) / 60
        calc_hospital_base = "#{day_time_hours_worked} x #{rate.hospital_weekday} + #{night_time_hours_worked} x #{rate.hospital_weeknight}"
      when "WEEKEND_FACTOR"
        base = (day_mins * rate.hospital_weekend + night_mins * rate.hospital_weekend_night) / 60
        calc_hospital_base = "#{day_time_hours_worked} x #{rate.hospital_weekend} + #{night_time_hours_worked} x #{rate.hospital_weekend_night}"
      when "BANK_HOLIDAY_FACTOR"
        base = (day_mins * rate.hospital_bank_holiday + night_mins * rate.hospital_bank_holiday) / 60
        calc_hospital_base = "#{day_time_hours_worked} x #{rate.hospital_bank_holiday} + #{night_time_hours_worked} x #{rate.hospital_bank_holiday}"
    end

    return base, day_mins, night_mins, calc_hospital_base

  end


  # Give a price estimate for the request
  def price_estimate(staffing_request)
    rate = billing_rate(staffing_request)

    # Ensure we get the factor for weekend, bank holiday or surge pricing
    factor_name = factor(staffing_request)
    
    # Basic rate multiplication
    nurse_base, day_mins, night_mins, calc_nurse_base = nurse_amount(staffing_request, rate, factor_name)
    hospital_base, day_mins, night_mins, calc_hospital_base = hospital_amount(staffing_request, rate, factor_name)
    nurse_base = nurse_base.round(2)
    hospital_base = hospital_base.round(2)

    # Audit trail
    day_time_hours_worked = staffing_request.human_readable_time(day_mins.to_i)
    night_time_hours_worked = staffing_request.human_readable_time(night_mins.to_i)

    staffing_request.nurse_base = nurse_base 
    staffing_request.hospital_base = hospital_base 
    staffing_request.vat = hospital_base * ENV["VAT"].to_f.round(2) 
    staffing_request.hospital_total_amount = (hospital_base + staffing_request.vat).round(2)

    staffing_request.pricing_audit["calc"] = "day_time_hours_worked x rate + night_time_hours_worked x rate"   
    staffing_request.pricing_audit["calc_nurse_base"] = calc_nurse_base   
    staffing_request.pricing_audit["calc_hospital_base"] = calc_hospital_base   
    staffing_request.pricing_audit["day_time_hours_worked"] = day_time_hours_worked
    staffing_request.pricing_audit["night_time_hours_worked"] = night_time_hours_worked
    staffing_request.pricing_audit["nurse_break_mins"] = staffing_request.nurse_break_mins
    staffing_request.pricing_audit["rate"] = rate.serializable_hash
    staffing_request.pricing_audit["nurse_base"] = nurse_base
    staffing_request.pricing_audit["hospital_base"] = hospital_base
    staffing_request.pricing_audit["factor_name"] = factor_name
    staffing_request.pricing_audit["vat"] = staffing_request.vat

    logger.debug(staffing_request.pricing_audit)

    staffing_request

  end

  # Give the actual price for the hours worked in the shift
  def price_actual(shift)
    staffing_request = shift.staffing_request

    rate = billing_rate(staffing_request)

    # Ensure we get the factor for weekend, bank holiday or surge pricing
    factor_name = factor(staffing_request)
    
    # Basic rate multiplication 
    nurse_base, day_mins, night_mins, calc_nurse_base = nurse_amount(shift, rate, factor_name)
    hospital_base, day_mins, night_mins, calc_hospital_base = hospital_amount(shift, rate, factor_name)
    nurse_base = nurse_base.round(2)
    hospital_base = hospital_base.round(2)

    vat = hospital_base * ENV["VAT"].to_f.round(2)     
    markup = (hospital_base - nurse_base).round(2)

    # Audit trail
    day_time_hours_worked = shift.human_readable_time(day_mins.to_i)
    night_time_hours_worked = shift.human_readable_time(night_mins.to_i)

    shift.pricing_audit["calc"] = "day_time_hours_worked x rate + night_time_hours_worked x rate"   
    shift.pricing_audit["calc_nurse_base"] = calc_nurse_base   
    shift.pricing_audit["calc_hospital_base"] = calc_hospital_base   
    
    shift.pricing_audit["day_time_hours_worked"] = day_time_hours_worked
    shift.pricing_audit["night_time_hours_worked"] = night_time_hours_worked
    shift.pricing_audit["nurse_break_mins"] = shift.nurse_break_mins
    shift.pricing_audit["rate"] = rate.serializable_hash
    shift.pricing_audit["nurse_base"] = nurse_base
    shift.pricing_audit["hospital_base"] = hospital_base
    shift.pricing_audit["factor_name"] = factor_name
    shift.pricing_audit["vat"] = vat
    shift.pricing_audit["markup"] = markup

    # Add the pricing data to the shift
    shift.hospital_base = hospital_base
    shift.vat = vat
    shift.markup = markup
    shift.nurse_base = (hospital_base - markup).round(2)
    shift.hospital_total_amount = (hospital_base + vat).round(2)

    # Add the mins worked to the shift
    shift.day_mins_worked = day_mins
    shift.night_mins_worked = night_mins
    shift.total_mins_worked = day_mins + night_mins

    logger.debug("pricing_audit = #{shift.pricing_audit}")

    shift

  end


  def billing_rate(staffing_request)
    
    rate = nil

    # the rate based on zone and role
    base_rate = Rate.where(zone: staffing_request.hospital.zone, role: staffing_request.role)
    # Add speciality
    speciality_rate = base_rate.where(speciality: staffing_request.speciality)
    # No speciality - its a generalist rate
    generalist_rate = base_rate.where(speciality: "Generalist")
    # Get the rate for the speciality if there is one
    if (staffing_request.speciality)        
        # speciality rate for the specific care home if it exists
        custom_speciality_rate = speciality_rate.where(hospital_id: staffing_request.hospital_id).first
        rate = custom_speciality_rate ? custom_speciality_rate : speciality_rate.where(hospital_id: nil).first
    end
    # Get the Generalist rate if we have no rate
    if(rate == nil)
        # generalist rate for the specific care home if it exists
        custom_generalist_rate = generalist_rate.where(hospital_id: staffing_request.hospital_id).first
        rate = custom_generalist_rate ? custom_generalist_rate : generalist_rate.where(hospital_id: nil).first
    end

    rate
    
  end

  def factor(staffing_request)

    factor_name = "DEFAULT_FACTOR"
    # Now check if we need to multiply by a factor - weekend booking ?
    if(staffing_request.start_date.on_weekend? || staffing_request.end_date.on_weekend?)
      logger.debug("Weekend factor applied to request #{staffing_request.start_date} #{staffing_request.start_date.on_weekend?} #{staffing_request.end_date} #{staffing_request.end_date.on_weekend?}" )
      factor_name = "WEEKEND_FACTOR"
    end
    # Check last minute booking ?
    
    # if(staffing_request.booking_start_diff_hrs <= 3)
    #   logger.debug("Last minute factor applied to request booking_start_diff_hrs = #{staffing_request.booking_start_diff_hrs}")
    #   factor_name = "LAST_MINUTE_FACTOR"
    # end

    # Bank holiday ?
    if(Holiday.isBankHoliday?(staffing_request.start_date) || Holiday.isBankHoliday?(staffing_request.end_date))
      logger.debug("Bank holiday factor applied to request #{staffing_request.start_date} #{Holiday.isBankHoliday?(staffing_request.start_date)} #{staffing_request.end_date} #{Holiday.isBankHoliday?(staffing_request.end_date)}")
      factor_name = "BANK_HOLIDAY_FACTOR"
    end
    
    return factor_name

  end

  

end
