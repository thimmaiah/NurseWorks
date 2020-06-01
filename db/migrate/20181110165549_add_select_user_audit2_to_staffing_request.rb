class AddSelectUserAudit2ToStaffingRequest < ActiveRecord::Migration[5.0]
  def change
    add_column :staffing_requests, :select_user_audit, :text
    remove_column :staffing_requests, :selectUserAudit, :text
  end
end
