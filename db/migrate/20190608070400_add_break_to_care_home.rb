class AddBreakToCareHome < ActiveRecord::Migration[5.0]
  def change
    add_column :care_homes, :carer_break_mins, :integer, :default => 0
    add_column :staffing_requests, :carer_break_mins, :integer, :default => 0
    add_column :shifts, :carer_break_mins, :integer, :default => 0
  end
end
