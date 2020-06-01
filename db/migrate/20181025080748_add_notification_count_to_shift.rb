class AddNotificationCountToShift < ActiveRecord::Migration[5.0]
  def change
    add_column :shifts, :notification_count, :int
  end
end
