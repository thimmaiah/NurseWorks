# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

set :output, "log/cron_log.log"

every 1.day, :at => '3:30 am' do
  runner "ShiftCreatorJob.add_to_queue"
  runner "ShiftPendingJob.add_to_queue"
  runner "DocRefreshNotificationJob.perform_now"
  runner "ReferenceJob.perform_now"
  rake "db:backup"
end

every :reboot do
	rake "ts:regenerate"
	rake "assets:precompile"
	command "cd /home/ubuntu/NurseWorks/current && RAILS_ENV=production ./script/delayed_job start"
	command "cd /home/ubuntu/NurseWorks/current && sudo docker-compose -f config/elk-docker-compose.yml up -d"
	command "cd /home/ubuntu/NurseWorks/current && bundle exec pumactl -S /home/ubuntu/NurseWorks/shared/tmp/pids/puma.state -F /home/ubuntu/NurseWorks/shared/puma.rb restart"
end

every 60.minutes do
	runner "StatsMailer.request_with_no_responses.deliver_now"
end

every :friday, :at => "5pm" do
	runner "StatsMailer.stats_email.deliver_now"
end
