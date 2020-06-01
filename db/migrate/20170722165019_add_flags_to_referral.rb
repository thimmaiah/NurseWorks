class AddFlagsToReferral < ActiveRecord::Migration[5.0]
  def change
    add_column :referrals, :referral_status, :string, limit: 10
    add_column :referrals, :payment_status, :string, limit: 10
  end
end
