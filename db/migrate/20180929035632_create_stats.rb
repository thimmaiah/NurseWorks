class CreateStats < ActiveRecord::Migration[5.0]
  def change
    create_table :stats do |t|
      t.string :name, limit: 100
      t.string :description
      t.string :value

      t.timestamps
    end
  end
end
