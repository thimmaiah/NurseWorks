class AddCreatedByToUserDoc < ActiveRecord::Migration[5.0]
  def change
    add_column :user_docs, :created_by_user_id, :integer
  end
end
