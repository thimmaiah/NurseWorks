class AddSelectUserAuditToStaffingRequest < ActiveRecord::Migration[5.0]
  def change
    add_column :staffing_requests, :selectUserAudit, :text
  end
end
