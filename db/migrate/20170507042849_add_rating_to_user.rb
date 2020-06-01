class AddRatingToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :total_rating, :integer
    add_column :users, :rating_count, :integer
  end
end
