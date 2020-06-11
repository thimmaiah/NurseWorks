class ResetWeeklyAcceptedShiftsJob < ApplicationJob
    queue_as :default
  
    def perform(user)
      Rails.logger.debug "ResetWeeklyAcceptedShiftsJob: resetting user.weekly_accepted_shifts to 0"
      User.temps.update_all(weekly_accepted_shifts: 0)
    end
  end
  