module StartEndTimeHelper

  # Break is usually midway in the shift
  def break_time
    seconds_to_mid = (self.end_date - self.start_date).to_i / 2
    mid = self.start_date + seconds_to_mid.seconds
    mid
  end

  def minutes_worked
    if(self.start_date && self.end_date)
      minutes = ((self.end_date - self.start_date).to_f / 60).round(0).to_f
    else
      0
    end
  end

  def human_readable_time(minutes)
    "#{(minutes / 60).truncate(0)} hrs, #{(minutes % 60).round(0)} mins"
  end

  def day_shift_minutes
    self.minutes_worked - self.night_shift_minutes
  end

  def night_shift_minutes
    night_shift_start = 0
    night_shift_end   = 0
    night_shift_start2 = 0
    night_shift_end2   = 0

    minutes = nil

    logger.debug "self.start_date.hour = #{self.start_date.hour}, self.end_date.hour = #{self.end_date.hour}"

    if(self.start_date.day == self.end_date.day)
      if( (self.start_date.hour <= 8 && self.end_date.hour <= 8) ||
          (self.start_date.hour >= 20 && self.end_date.hour >= 20) ||
          (self.start_date.hour >= 20 && self.end_date.hour <= 8))
        night_shift_start = self.start_date
        night_shift_end   = self.end_date
        logger.debug "Condition 1"

      elsif(self.start_date.hour < 8 && self.end_date.hour >= 20)        
        # Here there are 2 separate night elements
        early_morning_shift = (self.end_date.change({hour:8,min:0,sec:0}) - self.start_date).to_f / 60
        late_night_shift = (self.end_date - self.end_date.change({hour:20,min:0,sec:0})).to_f / 60
        
        minutes = early_morning_shift + late_night_shift
        
        logger.debug "early_morning_shift = #{early_morning_shift} late_night_shift = #{late_night_shift} Condition 1.5"

      elsif(self.start_date.hour < 8 && self.end_date.hour >= 8)
        night_shift_start = self.start_date
        night_shift_end   = self.end_date.change({hour:8,min:0,sec:0})
        logger.debug "Condition 2"

      elsif(self.start_date.hour >= 20 && self.end_date.hour >= 8)
        night_shift_start = self.start_date
        night_shift_end = self.end_date.change({hour:8,min:0,sec:0})
        logger.debug "Condition 3"

      elsif(self.start_date.hour <= 20 && self.end_date.hour <= 8)
        night_shift_start = self.start_date.change({hour:20,min:0,sec:0})
        night_shift_end   = self.end_date
        logger.debug "Condition 4"

      elsif(self.start_date.hour <= 20 && self.end_date.hour >= 20)
        night_shift_start = self.start_date.change({hour:20,min:0,sec:0})
        night_shift_end = self.end_date
        logger.debug "Condition 5"

      elsif(self.start_date.hour >= 8 && self.end_date.hour <= 20)
        night_shift_start = 0
        night_shift_end   = 0
        logger.debug "Condition 6"
      end
    end

    if(self.start_date.day != self.end_date.day)

      if(self.start_date.hour <= 20 && self.end_date.hour >= 8)
        night_shift_start = self.start_date.change({hour:20,min:0,sec:0})
        night_shift_end = self.end_date.change({hour:8,min:0,sec:0})
        logger.debug "Condition 7"

      elsif(self.start_date.hour >=8 && self.start_date.hour <= 20 && self.end_date.hour <= 8)
        night_shift_start = self.start_date.change({hour:20,min:0,sec:0})
        night_shift_end = self.end_date
        logger.debug "Condition 8"

      elsif(self.start_date.hour >= 20 && self.end_date.hour >= 8 && self.end_date.hour <= 20)
        night_shift_start = self.start_date
        night_shift_end = self.end_date.change({hour:8,min:0,sec:0})
        logger.debug "Condition 9"

      elsif(self.start_date.hour >= 20 && self.end_date.hour <= 8)
        night_shift_start = self.start_date
        night_shift_end = self.end_date
        logger.debug "Condition 10"

      elsif(self.start_date.hour <= 8 && self.end_date.hour <= 8)
        # Here there are 2 separate night elements
        early_morning_shift = (self.start_date.change({hour:8,min:0,sec:0}) - self.start_date).to_f / 60
        late_night_shift = (self.end_date - self.start_date.change({hour:20,min:0,sec:0})).to_f / 60
        
        minutes = early_morning_shift + late_night_shift
        logger.debug "Condition 11"

      elsif(self.start_date.hour >= 20 && self.end_date.hour >= 20)
        # Here there are 2 separate night elements
        early_morning_shift = (self.end_date.change({hour:8,min:0,sec:0}) - self.start_date).to_f / 60
        late_night_shift = (self.end_date - self.end_date.change({hour:20,min:0,sec:0})).to_f / 60
        
        minutes = early_morning_shift + late_night_shift
        logger.debug "Condition 12"

      end
    end

    logger.debug "night_shift_end = #{night_shift_end}, night_shift_start = #{night_shift_start}, night_shift_end2 = #{night_shift_end2}, night_shift_start2 = #{night_shift_start2}"

    minutes = ((night_shift_end - night_shift_start).to_f / 60) if minutes == nil # Hack for Condition 10
    minutes = minutes.round(0).to_f
    logger.debug "minutes = #{minutes}"

    return minutes
  end


  # Calculates the number of business days in range (start_date, end_date]
  #
  # @param start_date [Date]
  # @param end_date [Date]
  #
  # @return [Fixnum]
  def self.business_days_between(start_date, end_date)
    days_between = (end_date - start_date).to_i
    return 0 unless days_between > 0

    # Assuming we need to calculate days from 9th to 25th, 10-23 are covered
    # by whole weeks, and 24-25 are extra days.
    #
    # Su Mo Tu We Th Fr Sa    # Su Mo Tu We Th Fr Sa
    #        1  2  3  4  5    #        1  2  3  4  5
    #  6  7  8  9 10 11 12    #  6  7  8  9 ww ww ww
    # 13 14 15 16 17 18 19    # ww ww ww ww ww ww ww
    # 20 21 22 23 24 25 26    # ww ww ww ww ed ed 26
    # 27 28 29 30 31          # 27 28 29 30 31
    whole_weeks, extra_days = days_between.divmod(7)

    unless extra_days.zero?
      # Extra days start from the week day next to start_day,
      # and end on end_date's week date. The position of the
      # start date in a week can be either before (the left calendar)
      # or after (the right one) the end date.
      #
      # Su Mo Tu We Th Fr Sa    # Su Mo Tu We Th Fr Sa
      #        1  2  3  4  5    #        1  2  3  4  5
      #  6  7  8  9 10 11 12    #  6  7  8  9 10 11 12
      # ## ## ## ## 17 18 19    # 13 14 15 16 ## ## ##
      # 20 21 22 23 24 25 26    # ## 21 22 23 24 25 26
      # 27 28 29 30 31          # 27 28 29 30 31
      #
      # If some of the extra_days fall on a weekend, they need to be subtracted.
      # In the first case only corner days can be days off,
      # and in the second case there are indeed two such days.
      extra_days -= if start_date.tomorrow.wday <= end_date.wday
                      [start_date.tomorrow.sunday?, end_date.saturday?].count(true)
                    else
                      2
                    end
    end

    (whole_weeks * 5) + extra_days
  end

end