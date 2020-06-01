class AddLatLngToCareHome < ActiveRecord::Migration[5.0]
  def change
    add_column :care_homes, :lat, :decimal, precision: 18, scale: 15
    add_column :care_homes, :lng, :decimal, precision: 18, scale: 15
  end
end
