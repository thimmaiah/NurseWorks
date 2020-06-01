class CreateUserDocs < ActiveRecord::Migration[5.0]
  def change
    create_table :user_docs do |t|
      t.string :name
      t.string :doc_type
      t.integer :user_id

      t.timestamps
    end
  end
end
