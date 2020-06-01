class AddAsOfDateToStat < ActiveRecord::Migration[5.0]
  def change
    add_column :stats, :as_of_date, :date
  end
end
