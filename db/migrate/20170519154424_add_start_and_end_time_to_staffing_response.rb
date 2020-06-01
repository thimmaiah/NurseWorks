class AddStartAndEndTimeToShift < ActiveRecord::Migration[5.0]
  def change
    add_column :shifts, :start_date, :datetime
    add_column :shifts, :end_date, :datetime
  end
end
