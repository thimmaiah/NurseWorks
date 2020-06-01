class AddQrCodeToCareHome < ActiveRecord::Migration[5.0]
  def change
    add_column :care_homes, :qr_code, :string, limit: 10
  end
end
