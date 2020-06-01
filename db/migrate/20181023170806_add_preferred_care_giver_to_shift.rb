class AddPreferredCareGiverToShift < ActiveRecord::Migration[5.0]
  def change
    add_column :shifts, :preferred_care_giver_selected, :boolean
  end
end
