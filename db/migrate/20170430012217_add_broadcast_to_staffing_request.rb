class AddBroadcastToStaffingRequest < ActiveRecord::Migration[5.0]
  def change
    add_column :staffing_requests, :broadcast_status, :string
  end
end
