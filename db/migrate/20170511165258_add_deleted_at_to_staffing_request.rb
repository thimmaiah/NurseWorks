class AddDeletedAtToStaffingRequest < ActiveRecord::Migration[5.0]
  def change
    add_column :staffing_requests, :deleted_at, :datetime
    add_index :staffing_requests, :deleted_at
  end
end
