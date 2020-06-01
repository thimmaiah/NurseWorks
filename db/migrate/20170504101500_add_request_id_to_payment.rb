class AddRequestIdToPayment < ActiveRecord::Migration[5.0]
  def change
    add_column :payments, :staffing_request_id, :integer
    add_index :payments, :staffing_request_id
  end
end
