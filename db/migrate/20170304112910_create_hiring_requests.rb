class CreateHiringRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :hiring_requests do |t|
      t.date :start_date
      t.string :start_time, limit:20
      t.date :end_date
      t.integer :num_of_hours
      t.float :rate
      t.string :req_type, limit:20
      t.integer :user_id
      t.integer :care_home_id

      t.timestamps
    end
  end
end
