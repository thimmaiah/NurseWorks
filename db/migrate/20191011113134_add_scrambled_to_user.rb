class AddScrambledToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :scrambled, :boolean, :default=>false
    User.update_all(scrambled: false)
    User.where(address: "Deleted").update_all(scrambled: true)    
  end
end
