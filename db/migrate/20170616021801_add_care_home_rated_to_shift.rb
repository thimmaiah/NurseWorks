class AddCareHomeRatedToShift < ActiveRecord::Migration[5.0]
  def change
    add_column :shifts, :care_home_rated, :boolean
  end
end
