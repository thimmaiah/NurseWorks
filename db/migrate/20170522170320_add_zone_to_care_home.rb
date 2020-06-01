class AddZoneToCareHome < ActiveRecord::Migration[5.0]
  def change
    add_column :care_homes, :zone, :string
  end
end
