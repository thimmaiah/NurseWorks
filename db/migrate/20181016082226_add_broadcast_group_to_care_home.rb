class AddBroadcastGroupToCareHome < ActiveRecord::Migration[5.0]
  def change
    add_column :care_homes, :care_home_broadcast_group, :string
  end
end
