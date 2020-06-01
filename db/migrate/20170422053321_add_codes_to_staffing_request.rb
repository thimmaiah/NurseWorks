class AddCodesToStaffingRequest < ActiveRecord::Migration[5.0]
  def change
    add_column :staffing_requests, :start_code, :string, limit: 10
    add_column :staffing_requests, :end_code, :string, limit: 10
  end
end
