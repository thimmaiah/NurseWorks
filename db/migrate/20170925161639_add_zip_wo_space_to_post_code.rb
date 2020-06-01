class AddZipWoSpaceToPostCode < ActiveRecord::Migration[5.0]
  def change
    add_column :post_codes, :postcode_wo_spaces, :string
  end
end
