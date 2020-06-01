class CreateTrainings < ActiveRecord::Migration[5.0]
  def change
    create_table :trainings do |t|
      t.string :name
      t.boolean :undertaken
      t.date :date_completed
      t.integer :profile_id
      t.integer :user_id

      t.timestamps
    end
  end
end
