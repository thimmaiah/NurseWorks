class DeleteDocsJob < ApplicationJob
  queue_as :default

  def perform(user)
    Rails.logger.debug "Deleting all docs for user #{user.id}"
    user.user_docs.each do |doc|
      doc.destroy
    end

    # user.profile.destroy
    # user.trainings.each do |t|
    # 	t.destroy
    # end
  end
end
