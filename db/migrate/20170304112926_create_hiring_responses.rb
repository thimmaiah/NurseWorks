class CreateHiringResponses < ActiveRecord::Migration[5.0]
  def change
    create_table :hiring_responses do |t|
      t.integer :user_id
      t.integer :hiring_request_id
      t.text :notes

      t.timestamps
    end
  end
end
