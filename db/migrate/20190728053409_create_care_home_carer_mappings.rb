class CreateCareHomeCarerMappings < ActiveRecord::Migration[5.0]
  def change
    create_table :care_home_carer_mappings do |t|
      t.integer :care_home_id
      t.integer :user_id
      t.boolean :enabled
      t.float :distance
      t.boolean :manually_created
      t.integer :agency_id

      t.timestamps
    end
    add_index :care_home_carer_mappings, :care_home_id
    add_index :care_home_carer_mappings, :user_id
    add_index :care_home_carer_mappings, :agency_id
  end
end
