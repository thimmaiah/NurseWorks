class AddCreatedByUserToRating < ActiveRecord::Migration[5.0]
  def change
    add_column :ratings, :created_by_id, :integer
  end
end
