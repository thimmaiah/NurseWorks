class CreateProfiles < ActiveRecord::Migration[5.0]
  def change
    create_table :profiles do |t|
      t.integer :user_id
      t.date :date_of_CRB_DBS_check
      t.date :dob
      t.string :pin, limit: 15
      t.boolean :enhanced_crb
      t.boolean :crd_dbs_returned
      t.boolean :isa_returned
      t.string :crd_dbs_number, limit: 20
      t.boolean :eligible_to_work_UK
      t.boolean :confirmation_of_identity
      t.date :references_received
      t.boolean :dl_passport
      t.boolean :all_required_paperwork_checked
      t.boolean :registered_under_disability_act
      t.boolean :connuct_policies
      t.string :form_completed_by, limit: 50
      t.string :position, limit: 25
      t.date :date_sent
      t.date :date_received
      t.string :known_as, limit: 50
      t.string :role, limit: 25

      t.timestamps
    end
  end
end
