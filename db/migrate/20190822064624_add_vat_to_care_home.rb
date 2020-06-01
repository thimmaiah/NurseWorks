class AddVatToCareHome < ActiveRecord::Migration[5.0]
  def change
    add_column :care_homes, :vat_number, :string, limit: 50
    add_column :care_homes, :company_registration_number, :string, limit:100
    add_column :care_homes, :parking_available, :boolean
    add_column :care_homes, :paid_unpaid_breaks, :string, limit:10
    add_column :care_homes, :break_minutes, :integer
    add_column :care_homes, :meals_provided_on_shift, :boolean
    add_column :care_homes, :meals_subsidised, :boolean
    add_column :care_homes, :dress_code, :string
    add_column :care_homes, :po_req_for_invoice, :boolean
  end
end
