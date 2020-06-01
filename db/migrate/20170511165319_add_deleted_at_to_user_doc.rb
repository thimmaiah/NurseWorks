class AddDeletedAtToUserDoc < ActiveRecord::Migration[5.0]
  def change
    add_column :user_docs, :deleted_at, :datetime
    add_index :user_docs, :deleted_at
  end
end
