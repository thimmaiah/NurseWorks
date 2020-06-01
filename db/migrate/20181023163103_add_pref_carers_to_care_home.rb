class AddPrefCarersToCareHome < ActiveRecord::Migration[5.0]
  def change
    add_column :care_homes, :preferred_care_giver_ids, :string
  end
end
