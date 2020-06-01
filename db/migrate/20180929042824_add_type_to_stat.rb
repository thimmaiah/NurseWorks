class AddTypeToStat < ActiveRecord::Migration[5.0]
  def change
    add_column :stats, :stat_type, :string, limit: 20
  end
end
