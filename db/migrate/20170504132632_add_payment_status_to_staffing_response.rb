class AddPaymentStatusToShift < ActiveRecord::Migration[5.0]
  def change
    add_column :shifts, :payment_status, :string, limit: 10
  end
end
