class CreateAgencyUserMappings < ActiveRecord::Migration[5.0]
  def change
    create_table :agency_user_mappings do |t|
      t.belongs_to :agency, foreign_key: true
      t.belongs_to :user, foreign_key: true

      t.timestamps
      # add_index  :agency_user_mappings, :agency_id
      # add_index  :agency_user_mappings, :user_id
    end
  end
end
