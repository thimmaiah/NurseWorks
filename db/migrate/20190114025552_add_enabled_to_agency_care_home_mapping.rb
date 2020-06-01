class AddEnabledToAgencyCareHomeMapping < ActiveRecord::Migration[5.0]
  def change
    add_column :agency_care_home_mappings, :enabled, :boolean
    add_column :agency_user_mappings, :enabled, :boolean
  end
end
