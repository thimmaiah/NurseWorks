class AddPushTokenToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :push_token, :text
  end
end
