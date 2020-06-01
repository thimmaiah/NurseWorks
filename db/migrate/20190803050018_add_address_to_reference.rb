class AddAddressToReference < ActiveRecord::Migration[5.0]
  def change
    add_column :references, :address, :text
    add_column :references, :received_on, :date
  end
end
