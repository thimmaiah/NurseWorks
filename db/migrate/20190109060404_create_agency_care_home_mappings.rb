class CreateAgencyCareHomeMappings < ActiveRecord::Migration[5.0]
  def change
    create_table :agency_care_home_mappings do |t|
      t.belongs_to :agency, foreign_key: true
      t.belongs_to :care_home, foreign_key: true

      t.timestamps
      # add_index  :agency_care_home_mappings, :agency_id
      # add_index  :agency_care_home_mappings, :care_home_id
    end
  end
end
