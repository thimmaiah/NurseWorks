class AddIndexToPostCodes < ActiveRecord::Migration[5.0]
  def change
	  add_index :postcodelatlng, :postcode
  end
end
