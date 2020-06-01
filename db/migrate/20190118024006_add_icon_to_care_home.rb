class AddIconToCareHome < ActiveRecord::Migration[5.0]
  def change
    add_column :care_homes, :icon_url, :string
  end
end
