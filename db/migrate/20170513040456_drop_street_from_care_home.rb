class DropStreetFromCareHome < ActiveRecord::Migration[5.0]
  def change
	remove_column :care_homes, :street
	remove_column :care_homes, :locality
  end
end
