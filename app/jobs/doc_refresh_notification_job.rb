class DocRefreshNotificationJob < ApplicationJob
  queue_as :default

  def perform
    UserDoc.joins(:user).where("users.scrambled=? and (expiry_date = ? or expiry_date = ? or expiry_date = ? or expiry_date = ?)", 
    	false, Date.today + 3.months, Date.today + 2.months, Date.today + 1.month, Date.today + 2.weeks).each do |user_doc|
    	UserNotifierMailer.doc_refresh_notification(user_doc).deliver_now
    end

    Training.joins(:user).where("users.scrambled=? and (expiry_date = ? or expiry_date = ? or expiry_date = ? or expiry_date = ?)", 
    	false, Date.today + 3.months, Date.today + 2.months, Date.today + 1.month, Date.today + 2.weeks).each do |training|
    	UserNotifierMailer.training_refresh_notification(training).deliver_now
    end

  end
end
