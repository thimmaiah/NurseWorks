class AddCancelReasonToStaffingRequest < ActiveRecord::Migration[5.0]
  def change
    add_column :staffing_requests, :reason, :string
    add_column :shifts, :reason, :string
  end
end
