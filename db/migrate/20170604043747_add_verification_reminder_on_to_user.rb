class AddVerificationReminderOnToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :verification_reminder, :date
  end
end
