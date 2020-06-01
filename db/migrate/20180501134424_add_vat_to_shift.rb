class AddVatToShift < ActiveRecord::Migration[5.0]
  def change
    add_column :shifts, :vat, :float
  end
end
