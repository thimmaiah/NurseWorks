class AddCarerBaseToStaffingRequest < ActiveRecord::Migration[5.0]
  def change
    add_column :staffing_requests, :carer_base, :float
  end
end
