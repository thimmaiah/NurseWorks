class AddImageLinkToCareHome < ActiveRecord::Migration[5.0]
  def change
    add_column :care_homes, :image_url, :text
  end
end
