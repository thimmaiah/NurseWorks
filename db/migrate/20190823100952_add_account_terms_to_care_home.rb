class AddAccountTermsToCareHome < ActiveRecord::Migration[5.0]
  def change
    add_column :care_homes, :account_payment_terms, :string, limit: 20
  end
end
