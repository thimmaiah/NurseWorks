class AddDurationToShift < ActiveRecord::Migration[5.0]
  def change
    add_column :shifts, :day_mins_worked, :integer
    add_column :shifts, :night_mins_worked, :integer
    add_column :shifts, :total_mins_worked, :integer
  end
end
