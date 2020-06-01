class CreatePostCodes < ActiveRecord::Migration[5.0]
  def change
    create_table :post_codes do |t|
      t.string :postcode, limit: 10
      t.decimal :latitude
      t.decimal :longitude

      t.timestamps
    end
    add_index :post_codes, :postcode
  end
end
