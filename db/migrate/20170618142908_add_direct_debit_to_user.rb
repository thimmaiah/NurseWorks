class AddDirectDebitToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :accept_bank_transactions, :boolean
    add_column :users, :accept_bank_transactions_date, :datetime
    add_column :care_homes, :accept_bank_transactions, :boolean
    add_column :care_homes, :accept_bank_transactions_date, :datetime
  end
end
