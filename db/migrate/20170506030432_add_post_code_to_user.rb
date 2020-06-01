class AddPostCodeToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :postcode, :string, limit: 10
  end
end
