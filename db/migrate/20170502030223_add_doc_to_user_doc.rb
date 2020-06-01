class AddDocToUserDoc < ActiveRecord::Migration[5.0]
  def change
  	add_attachment :user_docs, :doc
  end
end
