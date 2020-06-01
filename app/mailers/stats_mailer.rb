class StatsMailer < ApplicationMailer
	layout "system_mailer"
	def stats_email(week=Date.today.beginning_of_week)
		@week = week
	    mail( :to => "#{ENV['ADMIN_EMAIL']}, #{ENV['MGT_EMAIL']}",
	          :subject => "Stats for week of #{@week}" )
	end

	def request_with_no_responses
		@not_found = StaffingRequest.open.not_found
		@manual = StaffingRequest.open.manual_assignment
		mail( :to => "#{ENV['ADMIN_EMAIL']}, #{ENV['MGT_EMAIL']}",
	          :subject => "No responses: #{@not_found.count}, Manual Assignment: #{@manual.count}" )
	end
end