class AddAgencyIdToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :agency_id, :integer
    add_index :users, :agency_id
  end
end
