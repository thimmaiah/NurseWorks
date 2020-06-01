class CreatePayments < ActiveRecord::Migration[5.0]
  def change
    create_table :payments do |t|
      t.integer :shift_id
      t.integer :user_id
      t.integer :care_home_id
      t.integer :paid_by_id
      t.float :amount
      t.text :notes

      t.timestamps
    end


  add_index :payments, :user_id
  add_index :payments, :care_home_id
  add_index :payments, :shift_id
  
  end

end
