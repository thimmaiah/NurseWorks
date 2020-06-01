class AddCustomToRate < ActiveRecord::Migration[5.0]
  def change
    add_column :rates, :care_home_id, :integer
    add_index :rates, :care_home_id
  end
end
