class AddConfirmToShift < ActiveRecord::Migration[5.0]
  def change
    add_column :shifts, :confirm_sent_count, :integer
    add_column :shifts, :confirm_sent_at, :date
    add_column :shifts, :confirmed_status, :string
    add_column :shifts, :confirmed_count, :integer
    add_column :shifts, :confirmed_at, :date
  end
end
