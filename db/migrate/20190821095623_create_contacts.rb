class CreateContacts < ActiveRecord::Migration[5.0]
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :phone
      t.string :email
      t.string :relationship
      t.integer :user_id
      t.string :contact_type

      t.timestamps
    end
    add_index :contacts, :user_id
  end
end
