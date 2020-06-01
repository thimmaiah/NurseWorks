class DropColsFromCareHome < ActiveRecord::Migration[5.0]
  def change
  	remove_column :care_homes, :manual_assignment_flag
    remove_column :care_homes, :preferred_care_giver_ids
    remove_column :care_homes, :limit_shift_to_pref_carer    
  end
end
