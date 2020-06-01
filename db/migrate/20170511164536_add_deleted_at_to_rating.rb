class AddDeletedAtToRating < ActiveRecord::Migration[5.0]
  def change
    add_column :ratings, :deleted_at, :datetime
    add_index :ratings, :deleted_at
  end
end
