class AddCareHomePaymentStatusToShift < ActiveRecord::Migration[5.0]
  def change
    add_column :shifts, :care_home_payment_status, :string, limit: 10
  end
end
