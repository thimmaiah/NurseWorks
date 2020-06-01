class CreateRatings < ActiveRecord::Migration[5.0]
  def change
    create_table :ratings do |t|
      t.integer :user_id
      t.integer :shift_id
      t.integer :stars
      t.text :comments

      t.timestamps
    end

    add_index :ratings, :user_id
    add_index :ratings, :shift_id
  end
end
