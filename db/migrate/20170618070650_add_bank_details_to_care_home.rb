class AddBankDetailsToCareHome < ActiveRecord::Migration[5.0]
  def change
    add_column :care_homes, :bank_account, :string, limit: 8
    add_column :care_homes, :sort_code, :string, limit: 6
  end
end
