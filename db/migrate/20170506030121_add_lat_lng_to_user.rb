class AddLatLngToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :lat, :decimal, precision: 18, scale: 15
    add_column :users, :lng, :decimal, precision: 18, scale: 15
  end
end
