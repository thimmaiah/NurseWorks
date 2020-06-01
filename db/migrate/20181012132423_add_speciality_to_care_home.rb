class AddSpecialityToCareHome < ActiveRecord::Migration[5.0]
  def change
    add_column :care_homes, :speciality, :string, limit: 100
  end
end
