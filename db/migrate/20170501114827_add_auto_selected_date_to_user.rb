class AddAutoSelectedDateToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :auto_selected_date, :date
  end
end
