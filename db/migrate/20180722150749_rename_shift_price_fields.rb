class RenameShiftPriceFields < ActiveRecord::Migration[5.0]
  def change
	  rename_column :shifts, :billing, :care_home_base
	  rename_column :shifts, :price, :carer_base
	  rename_column :shifts, :total_price, :care_home_total_amount
	  rename_column :staffing_requests, :price, :care_home_base
	  rename_column :staffing_requests, :total_price, :care_home_total_amount
  end
end
