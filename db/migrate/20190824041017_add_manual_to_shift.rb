class AddManualToShift < ActiveRecord::Migration[5.0]
  def change
    add_column :shifts, :manual_assignment, :boolean
  end
end
