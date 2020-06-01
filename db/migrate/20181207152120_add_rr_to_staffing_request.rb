class AddRrToStaffingRequest < ActiveRecord::Migration[5.0]
  def change
    add_column :staffing_requests, :recurring_request_id, :integer
    add_index :staffing_requests, :recurring_request_id
  end
end
