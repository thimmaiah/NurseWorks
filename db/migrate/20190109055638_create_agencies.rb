class CreateAgencies < ActiveRecord::Migration[5.0]
  def change
    create_table :agencies do |t|
      t.string :name, limit: 100
      t.string :address
      t.string :postcode, limit: 10
      t.string :phone, limit: 15
      t.string :broadcast_group

      t.timestamps
    end
  end
end
