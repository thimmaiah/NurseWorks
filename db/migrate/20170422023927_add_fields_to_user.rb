class AddFieldsToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :sex, :string, limit: 1
    add_column :users, :phone, :string, limit: 15
    add_column :users, :address, :text
    add_column :users, :languages, :string
    add_column :users, :pref_commute_distance, :int
    add_column :users, :occupation, :string, limit: 20
    add_column :users, :speciality, :string, limit: 50
    add_column :users, :experience, :int
    add_column :users, :referal_code, :string, limit: 10
    add_column :users, :accept_terms, :boolean
  end
end
