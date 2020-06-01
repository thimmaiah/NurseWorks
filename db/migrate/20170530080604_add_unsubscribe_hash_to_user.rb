class AddUnsubscribeHashToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :unsubscribe_hash, :string
    add_index :users, :unsubscribe_hash
  end
end
