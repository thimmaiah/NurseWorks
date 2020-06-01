class AddVerifiedToCareHome < ActiveRecord::Migration[5.0]
  def change
    add_column :care_homes, :verified, :boolean
  end
end
