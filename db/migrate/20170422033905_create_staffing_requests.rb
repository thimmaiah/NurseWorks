class CreateStaffingRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :staffing_requests do |t|
      t.integer :care_home_id
      t.integer :user_id
      t.datetime :start_date
      t.datetime :end_date
      t.float :rate_per_hour
      t.string :request_status, limit: 20
      t.float :auto_deny_in
      t.integer :response_count
      t.string :payment_status, limit: 20

      t.timestamps
    end

    add_index :staffing_requests, :user_id
    add_index :staffing_requests, :care_home_id
    
  end
end
