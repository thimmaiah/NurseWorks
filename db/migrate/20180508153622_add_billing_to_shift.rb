class AddBillingToShift < ActiveRecord::Migration[5.0]
  def change
    add_column :shifts, :billing, :float
  end
end
