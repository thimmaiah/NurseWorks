class AddVerifiedToUserDoc < ActiveRecord::Migration[5.0]
  def change
  	add_column :user_docs, :verified, :boolean
  end
end
