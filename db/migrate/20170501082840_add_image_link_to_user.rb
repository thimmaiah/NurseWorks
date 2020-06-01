class AddImageLinkToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :image_url, :text
  end
end
