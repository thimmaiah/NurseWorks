class AddExpiryToUserDoc < ActiveRecord::Migration[5.0]
  def change
    add_column :user_docs, :expiry_date, :date
    add_column :user_docs, :uploaded_by_id, :integer
    add_column :user_docs, :training_id, :integer
  end
end
