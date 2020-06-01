class AddPhoneToCareHome < ActiveRecord::Migration[5.0]
  def change
    add_column :care_homes, :phone, :string, limit: 12
  end
end
