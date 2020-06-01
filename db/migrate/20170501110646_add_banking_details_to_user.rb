class AddBankingDetailsToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :sort_code, :string, limit: 6
    add_column :users, :bank_account, :string, limit: 8
  end
end
