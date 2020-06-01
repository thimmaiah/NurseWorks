class AddVatToPayment < ActiveRecord::Migration[5.0]
  def change
    add_column :payments, :billing, :float
    add_column :payments, :vat, :float
    add_column :payments, :markup, :float
    add_column :payments, :care_giver_amount, :float
  end
end
