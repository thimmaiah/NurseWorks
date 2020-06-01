class AddPreferredToCareHomeCarerMapping < ActiveRecord::Migration[5.0]
  def change
    add_column :care_home_carer_mappings, :preferred, :boolean
  end
end
