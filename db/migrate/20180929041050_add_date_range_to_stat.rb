class AddDateRangeToStat < ActiveRecord::Migration[5.0]
  def change
    add_column :stats, :date_range, :string, limit:40
  end
end
