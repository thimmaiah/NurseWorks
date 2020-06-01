class CreateReferences < ActiveRecord::Migration[5.0]
  def change
    create_table :references do |t|
      t.string :first_name, limit:50
      t.string :last_name, limit:50
      t.string :title, limit:10
      t.string :email, limit:100
      t.string :ref_type, limit:25
      t.integer :user_id

      t.timestamps
    end
    add_index :references, :user_id
  end
end
