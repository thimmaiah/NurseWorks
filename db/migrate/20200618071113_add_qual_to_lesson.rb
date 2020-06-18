class AddQualToLesson < ActiveRecord::Migration[5.2]
  def change
    add_column :lessons, :key_qualifications, :text
    add_column :lessons, :specializations, :text
  end
end
