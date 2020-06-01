class AddNoShiftFlagToStaffingRequest < ActiveRecord::Migration[5.0]
  def change
    add_column :staffing_requests, :shift_status, :string
  end
end
