class AddCareHomeIdToShift < ActiveRecord::Migration[5.0]
   add_column :shifts, :care_home_id, :integer
  add_index :shifts, :care_home_id
end
