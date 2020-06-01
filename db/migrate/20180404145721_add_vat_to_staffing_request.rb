class AddVatToStaffingRequest < ActiveRecord::Migration[5.0]
  def change
    add_column :staffing_requests, :vat, :float
    add_column :staffing_requests, :total_price, :float
    add_column :shifts, :markup, :float
    add_column :shifts, :total_price, :float
  end
end
