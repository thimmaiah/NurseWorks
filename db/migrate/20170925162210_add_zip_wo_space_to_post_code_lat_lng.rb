class AddZipWoSpaceToPostCodeLatLng < ActiveRecord::Migration[5.0]
  def change
    add_column :postcodelatlng, :postcode_wo_spaces, :string
  end
end
