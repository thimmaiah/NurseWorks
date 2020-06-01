class AddNextGenerationDateToRecurringRequest < ActiveRecord::Migration[5.0]
  def change
    add_column :recurring_requests, :next_generation_date, :date
    add_index  :recurring_requests, :next_generation_date
  end
end
