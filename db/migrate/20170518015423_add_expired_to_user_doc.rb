class AddExpiredToUserDoc < ActiveRecord::Migration[5.0]
  def change
	  add_column :user_docs, :expired, :boolean
  end
end
