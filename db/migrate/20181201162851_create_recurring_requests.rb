class CreateRecurringRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :recurring_requests do |t|
      t.integer :care_home_id
      t.integer :user_id
      t.datetime :start_date
      t.datetime :end_date
      t.string :role, limit: 20
      t.string :speciality, limit: 50
      t.string :on
      t.date :start_on
      t.date :end_on
      t.text :audit

      t.timestamps
    end
    add_index :recurring_requests, :care_home_id
    add_index :recurring_requests, :user_id

    add_index :recurring_requests, :start_on
    add_index :recurring_requests, :end_on
  end
end
