class AddSisterCareHomesToCareHome < ActiveRecord::Migration[5.0]
  def change
    add_column :care_homes, :sister_care_homes, :string, limit: 30
  end
end
