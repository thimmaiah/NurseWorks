class CreateSchools < ActiveRecord::Migration[5.2]
  def change
    create_table :schools do |t|
      t.string :name, limit: 100
      t.string :address
      t.integer :rank

      t.timestamps
    end
  end
end
