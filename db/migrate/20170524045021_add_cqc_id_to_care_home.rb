class AddCqcIdToCareHome < ActiveRecord::Migration[5.0]
  def change
    add_column :care_homes, :cqc_location, :string
    add_index :care_homes, :cqc_location
  end
end
