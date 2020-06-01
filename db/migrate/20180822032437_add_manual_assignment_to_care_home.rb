class AddManualAssignmentToCareHome < ActiveRecord::Migration[5.0]
  def change
    add_column :care_homes, :manual_assignment_flag, :boolean
  end
end
