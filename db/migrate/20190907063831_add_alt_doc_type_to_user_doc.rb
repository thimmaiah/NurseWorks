class AddAltDocTypeToUserDoc < ActiveRecord::Migration[5.0]
  def change
    add_column :user_docs, :alt_doc_type, :string, limit: 25
  end
end
