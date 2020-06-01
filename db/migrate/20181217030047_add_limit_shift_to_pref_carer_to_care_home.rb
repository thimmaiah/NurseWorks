class AddLimitShiftToPrefCarerToCareHome < ActiveRecord::Migration[5.0]
  def change
    add_column :care_homes, :limit_shift_to_pref_carer, :boolean
  end
end
