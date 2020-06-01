class AddCodeToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :sms_verification_code, :string, limit: 5
  end
end
