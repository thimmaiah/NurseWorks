class AddAgencyIdToStaffingRequest < ActiveRecord::Migration[5.0]
  def change
    add_column :staffing_requests, :agency_id, :integer
    add_index :staffing_requests, :agency_id

    add_column :recurring_requests, :agency_id, :integer
    add_index :recurring_requests, :agency_id

    add_column :shifts, :agency_id, :integer
    add_index :shifts, :agency_id

    add_column :payments, :agency_id, :integer
    add_index :payments, :agency_id

	add_column :profiles, :agency_id, :integer
    add_index :profiles, :agency_id

    add_column :rates, :agency_id, :integer
    add_index :rates, :agency_id
    
    add_column :stats, :agency_id, :integer
    add_index :stats, :agency_id

    add_column :trainings, :agency_id, :integer
    add_index :trainings, :agency_id

    add_column :ratings, :agency_id, :integer
    add_index :ratings, :agency_id
  end
end
