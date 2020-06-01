class AddIndexToProfile < ActiveRecord::Migration[5.0]
  def change
	  add_index :profiles, :user_id
	  add_index :trainings, :user_id
	  add_index :trainings, :profile_id
  end
end
