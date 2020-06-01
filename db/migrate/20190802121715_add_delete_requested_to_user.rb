class AddDeleteRequestedToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :delete_requested, :boolean
  end
end
