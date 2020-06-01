class AddManualCloseToShift < ActiveRecord::Migration[5.0]
  def change
    add_column :shifts, :manual_close, :boolean
  end
end
