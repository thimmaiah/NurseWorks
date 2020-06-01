class AddCareHomeToRating < ActiveRecord::Migration[5.0]
  def change
    add_column :ratings, :care_home_id, :integer
  end
end
