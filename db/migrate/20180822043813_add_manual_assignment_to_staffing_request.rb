class AddManualAssignmentToStaffingRequest < ActiveRecord::Migration[5.0]
  def change
    add_column :staffing_requests, :manual_assignment_flag, :boolean
  end
end
