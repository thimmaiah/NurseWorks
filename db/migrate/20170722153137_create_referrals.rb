class CreateReferrals < ActiveRecord::Migration[5.0]
  def change
    create_table :referrals do |t|
      t.string :first_name, limit: 50
      t.string :last_name, limit: 50
      t.string :email
      t.string :role, limit: 15
      t.integer :user_id

      t.timestamps
    end

    add_index :referrals, :email
    add_index :referrals, :user_id
  end
end
