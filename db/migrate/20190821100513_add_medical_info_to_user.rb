class AddMedicalInfoToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :medical_info, :text
  end
end
