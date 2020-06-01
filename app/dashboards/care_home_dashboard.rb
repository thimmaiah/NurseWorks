require "administrate/base_dashboard"

class CareHomeDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    zone: Field::Select.with_options(collection: CareHome::ZONES),
    users: Field::HasMany,
    staffing_requests: Field::HasMany.with_options(limit: 10, sort_by: :start_date),
    care_home_carer_mappings: Field::HasMany,
    name: Field::String,
    speciality: Field::Select.with_options(collection: User::SPECIALITY),
    phone: Field::String,
    address: Field::String.with_options(required: true),
    town: Field::String.with_options(required: true),
    postcode: Field::String.with_options(required: true),
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    image_url: Field::Text,
    sister_care_homes: Field::String,
    care_home_broadcast_group: Field::String,
    carer_break_mins: Field::Select.with_options(collection: [30, 60]),
    qr_code: QrCodeField,
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
    :speciality,
    :sister_care_homes,
    :town,
    :zone
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :name,
    :verified,
    :qr_code,
    :speciality,
    :phone,
    :zone,
    :care_home_broadcast_group,
    :sister_care_homes,
    :address,
    :town,
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
    :care_home_carer_mappings,
    :staffing_requests,

  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :name,
    :speciality,
    :phone,
    :care_home_broadcast_group,
    :sister_care_homes,
    :address,
    :town,
    :postcode,
    :image_url,
    :zone,
    :account_payment_terms,
    :qr_code,
    :vat_number,
    :company_registration_number,
    :parking_available,
    :paid_unpaid_breaks,
    :carer_break_mins,
    :meals_provided_on_shift,
    :meals_subsidised,
    :dress_code,
    :po_req_for_invoice,
  ].freeze

  # Overwrite this method to customize how care_homes are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(care_home)
    "#{care_home.name} #{care_home.id}"
  end
end
