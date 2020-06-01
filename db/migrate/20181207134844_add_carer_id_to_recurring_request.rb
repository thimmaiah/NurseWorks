class AddCarerIdToRecurringRequest < ActiveRecord::Migration[5.0]
  def change
    add_column :recurring_requests, :preferred_carer_id, :integer
    add_column :staffing_requests, :preferred_carer_id, :integer
  end
end
