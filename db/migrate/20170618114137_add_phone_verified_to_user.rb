class AddPhoneVerifiedToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :phone_verified, :boolean
  end
end
