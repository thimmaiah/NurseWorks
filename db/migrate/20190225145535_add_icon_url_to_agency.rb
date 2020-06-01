class AddIconUrlToAgency < ActiveRecord::Migration[5.0]
  def change
    add_column :agencies, :icon_url, :text
  end
end
