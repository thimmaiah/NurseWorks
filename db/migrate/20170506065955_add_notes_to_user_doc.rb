class AddNotesToUserDoc < ActiveRecord::Migration[5.0]
  def change
    add_column :user_docs, :notes, :text
  end
end
