class AddDeletedAtToCareHome < ActiveRecord::Migration[5.0]
  def change
    add_column :care_homes, :deleted_at, :datetime
    add_index :care_homes, :deleted_at
  end
end
