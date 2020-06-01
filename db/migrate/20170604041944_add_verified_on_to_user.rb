class AddVerifiedOnToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :verified_on, :date
  end
end
