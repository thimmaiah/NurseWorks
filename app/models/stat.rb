class Stat < ApplicationRecord

  
  after_save ThinkingSphinx::RealTime.callback_for(:stat)

  def self.generate_all(date=Date.today)
  	Rails.logger.debug "Generating stats for #{date}"
    self.user_stats(date)
    self.hospital_stats(date)
    self.staffing_request_stats(date)
    self.shift_stats(date)
    self.generate_financials(date)
  end


  def self.init(type, date=Date.today, delete_prev=false)
    week = date.beginning_of_week
    month = date.beginning_of_month

    Stat.where("stat_type = ? and date_range in (?)", type, ["Week of #{week}", "Month of #{month}", "All Time"]).delete_all if delete_prev

    return week, month, type
  end

  def self.createWeekMonthAllStats(date, type, query, description=nil, delete_prev=false)

      week, month, type = init(type, date,delete_prev)

      description ||= "Stat #{type} on #{date}"

      Stat.create(name: name, stat_type: type, description: description,
                  as_of_date: date, date_range: "Week of #{week}", 
                  value: query.where("created_at >= ? and created_at <= ?", 
                    week, week.end_of_week).count)

      Stat.create(name: name, stat_type: type, description: description,
                  as_of_date: date, date_range: "Month of #{month}", 
                  value: query.where("created_at >= ? and created_at <= ?", 
                    month, month.end_of_month).count)

      Stat.create(name: name, stat_type: type, description: description,
                  as_of_date: date, date_range: "All time", 
                  value: query.count)

  end


  def self.important_stat(date=Date.today)
    week. month, type = init("Important", date)

  end

  def self.user_stats(date=Date.today)


    [true, false].each do |verified|
      vFlag = verified ? "Verified" : "Unverified"

      query, description, delete_prev = User.where("verified=?", verified), "All #{vFlag} users", true
      # self.createWeekMonthAllStats(date, "User", query, description, delete_prev)


      User::ROLE.each do |role|
        name = "Total #{vFlag} #{role} Count"

        query, description, delete_prev = User.where("verified=? and role=?", verified, role), "All #{vFlag} #{role} users", true
        self.createWeekMonthAllStats(date, "User", query, description, delete_prev)

      end
    end
  end



  def self.hospital_stats(date=Date.today)


    [true, false].each do |verified|
      vFlag = verified ? "Verified" : "Unverified"

      query, description, delete_prev = Hospital.where("verified=?", verified), "All #{vFlag} care homes", true
      self.createWeekMonthAllStats(date, "Hospital", query, description, delete_prev)


      # Hospital::ZONES.each do |zone|

      #   query, description, delete_prev = Hospital.where("verified=? and zone=?", verified, zone), "All #{vFlag} care homes in zone #{zone}", true
      #   self.createWeekMonthAllStats(date, "Hospital", query, description, delete_prev)

      # end
    end
  end

  def self.staffing_request_stats(date=Date.today)


    StaffingRequest::REQ_STATUS.each do |status|

      query, description, delete_prev = StaffingRequest.where("request_status=?", status), "#{status} StaffingRequest", true
      self.createWeekMonthAllStats(date, "StaffingRequest", query, description, delete_prev)

    end

    StaffingRequest::SHIFT_STATUS.each do |status|

      query, description, delete_prev = StaffingRequest.where("shift_status=?", status), "Shifts: #{status} StaffingRequest", true
      self.createWeekMonthAllStats(date, "StaffingRequest", query, description, delete_prev)

    end

  end

  def self.shift_stats(date=Date.today)


    Shift::RESPONSE_STATUS.each do |status|

      name = "Total #{status} Shift Count"
      desc = "#{status} Shift"

      query, description, delete_prev = Shift.where("response_status=?", status), "#{status} Shift", true
      self.createWeekMonthAllStats(date, "Shift", query, description, delete_prev)

    end

  end

  def self.generate_financials(date=Date.today)

    week = date.beginning_of_week
    month = date.beginning_of_month
    type = "Financials"
    desc = "Financials"
    status = "Closed"

    # We will regenerate this week, month and all time - so delete it before we regenerate
    Stat.where("stat_type = ? and date_range in (?)", type, ["Week of #{week}", "Month of #{month}", "All Time"]).delete_all


    Stat.create(name: "Income from Care Homes", stat_type: type, description: desc,
                as_of_date: date, date_range: "Week of #{week}", 
                value: Shift.where("response_status  =? and  created_at >= ? and created_at <= ?",
                      				status  , week, week.end_of_week).sum(:hospital_total_amount).round(2))

    Stat.create(name: "Expenses for Care Givers", stat_type: type, description: desc,
                as_of_date: date, date_range: "Week of #{week}",
                value: Shift.where("response_status  =? and  created_at >= ? and created_at <= ?",
                                   status  , week, week.end_of_week).sum(:carer_base).round(2))

    Stat.create(name: "Hours worked by Care Givers", stat_type: type, description: desc,
                as_of_date: date, date_range: "Week of #{week}",
                value: (Shift.where("response_status  =? and  created_at >= ? and created_at <= ?",
                                    status  , week, week.end_of_week).sum(:total_mins_worked) / 60).round(2))

    Stat.create(name: "Income from Care Homes", stat_type: type, description: desc,
                as_of_date: date, date_range: "Month of #{month}",
                value: Shift.where("response_status  =? and  created_at >= ? and created_at <= ?",
                                   status  , month, month.end_of_month).sum(:hospital_total_amount).round(2))

    Stat.create(name: "Expenses for Care Givers", stat_type: type, description: desc,
                as_of_date: date, date_range: "Month of #{month}",
                value: Shift.where("response_status  =? and  created_at >= ? and created_at <= ?",
                                   status  , month, month.end_of_month).sum(:carer_base).round(2))

    Stat.create(name: "Hours worked by Care Givers", stat_type: type, description: desc,
                as_of_date: date, date_range: "Month of #{month}",
                value: (Shift.where("response_status  =? and  created_at >= ? and created_at <= ?",
                                    status  , month, month.end_of_month).sum(:total_mins_worked) / 60).round(2))

    Stat.create(name: "Income from Care Homes", stat_type: type, description: desc,
                as_of_date: date, date_range: "All time",
                value: Shift.where("response_status  =?", status).sum(:hospital_total_amount).round(2))

    Stat.create(name: "Expenses for Care Givers", stat_type: type, description: desc,
                as_of_date: date, date_range: "All time",
                value: Shift.where("response_status  =?", status).sum(:carer_base).round(2))

    Stat.create(name: "Hours worked by Care Givers", stat_type: type, description: desc,
                as_of_date: date, date_range: "All time",
                value: (Shift.where("response_status  =? ", status).sum(:total_mins_worked) / 60).round(2))

  end

  def self.graph_data(stat_type, duration="Month")
    user_stats = Stat.search(duration, with: {stat_type: stat_type}, order: :as_of_date, page: 1, per_page: 100)
  end

  def self.generate_from(start_date)
  	s = start_date.end_of_week
  	while( s < Date.today.beginning_of_week ) 
  		self.generate_all(s)
  		s = s + 7.days
  	end
  end


end
