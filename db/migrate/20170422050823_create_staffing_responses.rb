class CreateShifts < ActiveRecord::Migration[5.0]
  def change
    create_table :shifts do |t|
      t.integer :staffing_request_id
      t.integer :user_id
      t.string :start_code, limit: 10
      t.string :end_code, limit: 10
      t.string :response_status, limit: 20
      t.boolean :accepted
      t.boolean :rated

      t.timestamps
    end
    add_index :shifts, :staffing_request_id
    add_index :shifts, :user_id
     
  end
end
