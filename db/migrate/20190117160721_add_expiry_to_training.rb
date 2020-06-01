class AddExpiryToTraining < ActiveRecord::Migration[5.0]
  def change
    add_column :trainings, :expiry_date, :date
    add_column :trainings, :vendor, :string
  end
end
