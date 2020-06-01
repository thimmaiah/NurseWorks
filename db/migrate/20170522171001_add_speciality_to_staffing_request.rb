class AddSpecialityToStaffingRequest < ActiveRecord::Migration[5.0]
  def change
    add_column :staffing_requests, :role, :string
    add_column :staffing_requests, :speciality, :string
  end
end
