class AddNotesToReferences < ActiveRecord::Migration[5.0]
  def change
    add_column :references, :notes, :text
    add_column :references, :reference_received, :boolean
  end
end
