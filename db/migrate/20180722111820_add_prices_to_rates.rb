class AddPricesToRates < ActiveRecord::Migration[5.0]
  def change
    add_column :rates, :carer_weekday, :float
    add_column :rates, :care_home_weekday, :float
    add_column :rates, :carer_weeknight, :float
    add_column :rates, :care_home_weeknight, :float
    add_column :rates, :carer_weekend, :float
    add_column :rates, :care_home_weekend, :float
    add_column :rates, :carer_weekend_night, :float
    add_column :rates, :care_home_weekend_night, :float
    add_column :rates, :carer_bank_holiday, :float
    add_column :rates, :care_home_bank_holiday, :float
  end
end
