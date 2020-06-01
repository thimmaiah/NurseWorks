class AddAcceptedToAgencyUserMapping < ActiveRecord::Migration[5.0]
  def change
    add_column :agency_user_mappings, :accepted, :boolean
    add_column :agency_care_home_mappings, :accepted, :boolean
    add_column :agency_user_mappings, :notes, :text
    add_column :agency_care_home_mappings, :notes, :text
  end
end
