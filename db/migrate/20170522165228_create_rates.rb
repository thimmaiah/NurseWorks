class CreateRates < ActiveRecord::Migration[5.0]
  def change
    create_table :rates do |t|
      t.string :zone
      t.string :role
      t.string :speciality
      t.float :amount

      t.timestamps
    end
  end
end
