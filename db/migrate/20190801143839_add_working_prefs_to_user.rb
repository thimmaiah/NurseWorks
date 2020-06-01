class AddWorkingPrefsToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :work_weekdays, :boolean
    add_column :users, :work_weeknights, :boolean
    add_column :users, :work_weekends, :boolean
    add_column :users, :work_weekend_nights, :boolean
    add_column :users, :pause_shifts, :boolean
  end
end
