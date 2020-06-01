module RatesHelper

  def carer_amount(entity, rate, factor_name)
    total_mins = entity.minutes_worked 
    night_mins = entity.night_shift_minutes
    day_mins = total_mins - night_mins

    # Adjust the minutes worked by the unpaid break taken by the carer 
    if(entity.carer_break_mins > 0)
        if(entity.break_time.hour <= 8 || entity.break_time.hour >= 20) 
            # Break is in night time hours
            night_mins = night_mins - entity.carer_break_mins
        else
            # Break is in day time hours
            day_mins = day_mins - entity.carer_break_mins
        end 
    end

    day_time_hours_worked = entity.human_readable_time(day_mins.to_i)
    night_time_hours_worked = entity.human_readable_time(night_mins.to_i)

    logger.debug("total_mins = #{total_mins}, carer_break_mins=#{entity.carer_break_mins}, night_mins = #{night_mins}, day_mins = #{day_mins}, day_time_hours_worked = #{day_time_hours_worked}, night_time_hours_worked = #{night_time_hours_worked}")
    
    case factor_name
      when "DEFAULT_FACTOR"
        base = (day_mins * rate.carer_weekday + night_mins * rate.carer_weeknight) / 60
        calc_carer_base = "#{day_time_hours_worked} x #{rate.carer_weekday} + #{night_time_hours_worked} x #{rate.carer_weeknight}"
      when "WEEKEND_FACTOR"
        base = (day_mins * rate.carer_weekend + night_mins * rate.carer_weekend_night) / 60
        calc_carer_base = "#{day_time_hours_worked} x #{rate.carer_weekend} + #{night_time_hours_worked} x #{rate.carer_weekend_night}"
      when "BANK_HOLIDAY_FACTOR"
        base = (day_mins * rate.carer_bank_holiday + night_mins * rate.carer_bank_holiday) / 60
        calc_carer_base = "#{day_time_hours_worked} x #{rate.carer_bank_holiday} + #{night_time_hours_worked} x #{rate.carer_bank_holiday}"
    end

    return base, day_mins, night_mins, calc_carer_base

  end

  def care_home_amount(entity, rate, factor_name)
    total_mins = entity.minutes_worked 
    night_mins = entity.night_shift_minutes
    day_mins = total_mins - night_mins

    # Adjust the minutes worked by the unpaid break taken by the carer 
    if(entity.carer_break_mins > 0)
        if(entity.break_time.hour <= 8 || entity.break_time.hour >= 20) 
            # Break is in night time hours
            night_mins = night_mins - entity.carer_break_mins
        else
            # Break is in day time hours
            day_mins = day_mins - entity.carer_break_mins
        end 
    end

    day_time_hours_worked = entity.human_readable_time(day_mins.to_i)
    night_time_hours_worked = entity.human_readable_time(night_mins.to_i)

    logger.debug("total_mins = #{total_mins}, carer_break_mins=#{entity.carer_break_mins}, night_mins = #{night_mins}, day_mins = #{day_mins}, day_time_hours_worked = #{day_time_hours_worked}, night_time_hours_worked = #{night_time_hours_worked}")
    
    case factor_name
      when "DEFAULT_FACTOR"
        base = (day_mins * rate.care_home_weekday + night_mins * rate.care_home_weeknight) / 60
        calc_care_home_base = "#{day_time_hours_worked} x #{rate.care_home_weekday} + #{night_time_hours_worked} x #{rate.care_home_weeknight}"
      when "WEEKEND_FACTOR"
        base = (day_mins * rate.care_home_weekend + night_mins * rate.care_home_weekend_night) / 60
        calc_care_home_base = "#{day_time_hours_worked} x #{rate.care_home_weekend} + #{night_time_hours_worked} x #{rate.care_home_weekend_night}"
      when "BANK_HOLIDAY_FACTOR"
        base = (day_mins * rate.care_home_bank_holiday + night_mins * rate.care_home_bank_holiday) / 60
        calc_care_home_base = "#{day_time_hours_worked} x #{rate.care_home_bank_holiday} + #{night_time_hours_worked} x #{rate.care_home_bank_holiday}"
    end

    return base, day_mins, night_mins, calc_care_home_base

  end


  # Give a price estimate for the request
  def price_estimate(staffing_request)
    rate = billing_rate(staffing_request)

    # Ensure we get the factor for weekend, bank holiday or surge pricing
    factor_name = factor(staffing_request)
    
    # Basic rate multiplication
    carer_base, day_mins, night_mins, calc_carer_base = carer_amount(staffing_request, rate, factor_name)
    care_home_base, day_mins, night_mins, calc_care_home_base = care_home_amount(staffing_request, rate, factor_name)
    carer_base = carer_base.round(2)
    care_home_base = care_home_base.round(2)

    # Audit trail
    day_time_hours_worked = staffing_request.human_readable_time(day_mins.to_i)
    night_time_hours_worked = staffing_request.human_readable_time(night_mins.to_i)

    staffing_request.carer_base = carer_base 
    staffing_request.care_home_base = care_home_base 
    staffing_request.vat = care_home_base * ENV["VAT"].to_f.round(2) 
    staffing_request.care_home_total_amount = (care_home_base + staffing_request.vat).round(2)

    staffing_request.pricing_audit["calc"] = "day_time_hours_worked x rate + night_time_hours_worked x rate"   
    staffing_request.pricing_audit["calc_carer_base"] = calc_carer_base   
    staffing_request.pricing_audit["calc_care_home_base"] = calc_care_home_base   
    staffing_request.pricing_audit["day_time_hours_worked"] = day_time_hours_worked
    staffing_request.pricing_audit["night_time_hours_worked"] = night_time_hours_worked
    staffing_request.pricing_audit["carer_break_mins"] = staffing_request.carer_break_mins
    staffing_request.pricing_audit["rate"] = rate.serializable_hash
    staffing_request.pricing_audit["carer_base"] = carer_base
    staffing_request.pricing_audit["care_home_base"] = care_home_base
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
    carer_base, day_mins, night_mins, calc_carer_base = carer_amount(shift, rate, factor_name)
    care_home_base, day_mins, night_mins, calc_care_home_base = care_home_amount(shift, rate, factor_name)
    carer_base = carer_base.round(2)
    care_home_base = care_home_base.round(2)

    vat = care_home_base * ENV["VAT"].to_f.round(2)     
    markup = (care_home_base - carer_base).round(2)

    # Audit trail
    day_time_hours_worked = shift.human_readable_time(day_mins.to_i)
    night_time_hours_worked = shift.human_readable_time(night_mins.to_i)

    shift.pricing_audit["calc"] = "day_time_hours_worked x rate + night_time_hours_worked x rate"   
    shift.pricing_audit["calc_carer_base"] = calc_carer_base   
    shift.pricing_audit["calc_care_home_base"] = calc_care_home_base   
    
    shift.pricing_audit["day_time_hours_worked"] = day_time_hours_worked
    shift.pricing_audit["night_time_hours_worked"] = night_time_hours_worked
    shift.pricing_audit["carer_break_mins"] = shift.carer_break_mins
    shift.pricing_audit["rate"] = rate.serializable_hash
    shift.pricing_audit["carer_base"] = carer_base
    shift.pricing_audit["care_home_base"] = care_home_base
    shift.pricing_audit["factor_name"] = factor_name
    shift.pricing_audit["vat"] = vat
    shift.pricing_audit["markup"] = markup

    # Add the pricing data to the shift
    shift.care_home_base = care_home_base
    shift.vat = vat
    shift.markup = markup
    shift.carer_base = (care_home_base - markup).round(2)
    shift.care_home_total_amount = (care_home_base + vat).round(2)

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
    base_rate = Rate.where(zone: staffing_request.care_home.zone, role: staffing_request.role)
    # Add speciality
    speciality_rate = base_rate.where(speciality: staffing_request.speciality)
    # No speciality - its a generalist rate
    generalist_rate = base_rate.where(speciality: "Generalist")
    # Get the rate for the speciality if there is one
    if (staffing_request.speciality)        
        # speciality rate for the specific care home if it exists
        custom_speciality_rate = speciality_rate.where(care_home_id: staffing_request.care_home_id).first
        rate = custom_speciality_rate ? custom_speciality_rate : speciality_rate.where(care_home_id: nil).first
    end
    # Get the Generalist rate if we have no rate
    if(rate == nil)
        # generalist rate for the specific care home if it exists
        custom_generalist_rate = generalist_rate.where(care_home_id: staffing_request.care_home_id).first
        rate = custom_generalist_rate ? custom_generalist_rate : generalist_rate.where(care_home_id: nil).first
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
