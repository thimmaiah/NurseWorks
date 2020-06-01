class AddDatesToRecurringRequest < ActiveRecord::Migration[5.0]
  def change
    add_column :recurring_requests, :dates, :text
    add_column :recurring_requests, :notes, :text
  end
end
