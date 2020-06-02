require "administrate/base_dashboard"

class HospitalDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    zone: Field::Select.with_options(collection: Hospital::ZONES),
    
    users: Field::HasMany,
    staffing_requests: Field::HasMany.with_options(limit: 10, sort_by: :start_date),
    hospital_carer_mappings: Field::HasMany,
    name: Field::String,
    city: Field::String,
    specializations: CheckboxList.with_options(choices: User::SPECIALITY),
    phone: Field::String,
    address: Field::String.with_options(required: true),
    town: Field::String.with_options(required: true),
    postcode: Field::String.with_options(required: true),
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    image_url: Field::Text,
    sister_hospitals: Field::String,
    hospital_broadcast_group: Field::String,
    carer_break_mins: Field::Select.with_options(collection: [30, 60]),
    account_payment_terms: Field::Select.with_options(collection: ["", "14 days", "30 days"]), 
    vat_number: Field::String,
    company_registration_number: Field::String,
    dress_code: Field::String,
    parking_available: Field::BooleanToYesNo,
    paid_unpaid_breaks: Field::Select.with_options(collection: ["Paid", "Unpaid"]),
    meals_provided_on_shift: Field::BooleanToYesNo,
    po_req_for_invoice: Field::BooleanToYesNo,
    meals_subsidised:  Field::BooleanToYesNo,
    verified: Field::BooleanToYesNo,
    lat: Field::String.with_options(searchable: false),
    lng: Field::String.with_options(searchable: false),
    num_of_beds: Field::Number,  
    nurse_count: Field::Number,
    nurse_qualification_pct: Field::Text, 
    typical_workex: Field::Text, 
    owner_name: Field::String,

  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :name,
    :verified,
    :specializations,
    :sister_hospitals,
    :city,
    :num_of_beds,
    :zone
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :name,
    :verified,
    :specializations,
    :phone,
    :zone,
    :hospital_broadcast_group,
    :sister_hospitals,
    :address,
    :city,
    :num_of_beds, 
    :specializations, 
    :nurse_count,
    :nurse_qualification_pct, 
    :typical_workex, 
    :owner_name,
    :postcode,
    :account_payment_terms,
    :vat_number,
    :company_registration_number,
    :carer_break_mins,
    :paid_unpaid_breaks,
    :parking_available,
    :meals_provided_on_shift,
    :meals_subsidised,
    :po_req_for_invoice,
    :dress_code,
    :created_at,
    :updated_at,
    :image_url,
    :lat,
    :lng,
    :users,
    :hospital_carer_mappings,
    :staffing_requests,

  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :name,
    :specializations,
    :phone,
    :hospital_broadcast_group,
    :sister_hospitals,
    :address,
    :city,
    :postcode,
    :image_url,
    :zone,
    :account_payment_terms,
    :vat_number,
    :company_registration_number,
    :parking_available,
    :paid_unpaid_breaks,
    :carer_break_mins,
    :meals_provided_on_shift,
    :meals_subsidised,
    :dress_code,
    :po_req_for_invoice,
    :num_of_beds,  
    :nurse_count,
    :typical_workex, 
    :owner_name
  ].freeze

  # Overwrite this method to customize how hospitals are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(hospital)
    "#{hospital.name} #{hospital.id}"
  end
end
