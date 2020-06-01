class CreateCareHomes < ActiveRecord::Migration[5.0]
  def change
    create_table :care_homes do |t|
      t.string :name
      t.string :address
      t.string :street
      t.string :locality
      t.string :town
      t.string :postcode, limit:10
      t.float :base_rate

      t.timestamps
    end
  end
end
