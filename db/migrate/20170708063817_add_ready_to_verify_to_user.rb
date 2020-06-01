class AddReadyToVerifyToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :ready_for_verification, :boolean
  end
end
