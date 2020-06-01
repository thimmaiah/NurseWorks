class AddPriceToShift < ActiveRecord::Migration[5.0]
  def change
    add_column :shifts, :price, :float
    add_column :shifts, :pricing_audit, :text
  end
end
