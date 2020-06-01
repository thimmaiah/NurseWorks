class AddNotesToStaffingRequest < ActiveRecord::Migration[5.0]
  def change
    add_column :staffing_requests, :notes, :text
  end
end
