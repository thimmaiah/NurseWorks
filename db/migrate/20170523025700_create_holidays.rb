class CreateHolidays < ActiveRecord::Migration[5.0]
  def change
    create_table :holidays do |t|
      t.string :name
      t.date :date
      t.boolean :bank_holiday

      t.timestamps
    end
    add_index :holidays, :date
  end
end
