class GenerateIncentivesJob < ApplicationJob
  queue_as :default

  def perform()

  	# We need to generate the incentives for the prev month
    if Rails.env == "test"
      # For tests its hard to generate prev month shifts, so we do this month
      prev_month_start = Date.today.beginning_of_month
    else
  	 prev_month_start = Date.today.beginning_of_month.prev_month
    end
  	Rails.logger.debug "GenerateIncentivesJob: Generating incentives for month starting #{prev_month_start}"
  	# Find all the closed shifts for the prev month
  	prev_month_closed_shifts = Shift.month_closed_shifts(prev_month_start)
  	
    user_ids = prev_month_closed_shifts.distinct.pluck(:user_id)
    Rails.logger.debug "GenerateIncentivesJob: Found user_ids #{user_ids}"

    user_ids.each do |id|
    	# For each user generate the incentive for the prev month
    	user = User.find(id)
    	Rails.logger.debug "GenerateIncentivesJob: Generating incentive for user #{user.email}"
    	Payment.generate_incentive(user, prev_month_start)
    end
  end
end
