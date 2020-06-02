require "administrate/base_dashboard"

class RateDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    hospital_id: Field::Number,
    zone: Field::Select.with_options(collection: Hospital::ZONES),
    role: Field::Select.with_options(collection: User::ROLE),
    speciality: Field::Select.with_options(collection: User::SPECIALITY),
    hospital: Field::BelongsToSearch,
    carer_weekday: Field::Number.with_options(decimals: 2),
    hospital_weekday: Field::Number.with_options(decimals: 2),
    carer_weeknight: Field::Number.with_options(decimals: 2),
    hospital_weeknight: Field::Number.with_options(decimals: 2),
    carer_weekend: Field::Number.with_options(decimals: 2),
    hospital_weekend: Field::Number.with_options(decimals: 2),
    carer_weekend_night: Field::Number.with_options(decimals: 2),
    hospital_weekend_night: Field::Number.with_options(decimals: 2),
    carer_bank_holiday: Field::Number.with_options(decimals: 2),
    hospital_bank_holiday: Field::Number.with_options(decimals: 2),

    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :zone,
    :role,
    :hospital,
    :speciality,
    :carer_weekday,
    :hospital_weekday,
    :carer_weeknight,
    :hospital_weeknight,
    :carer_weekend,
    :hospital_weekend,
    :carer_weekend_night,
    :hospital_weekend_night,
    :carer_bank_holiday,
    :hospital_bank_holiday,    
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :hospital,
    :zone,
    :role,
    :speciality,
    :carer_weekday,
    :hospital_weekday,
    :carer_weeknight,
    :hospital_weeknight,
    :carer_weekend,
    :hospital_weekend,
    :carer_weekend_night,
    :hospital_weekend_night,
    :carer_bank_holiday,
    :hospital_bank_holiday,    
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :hospital,
    :zone,
    :role,
    :speciality,
    :carer_weekday,
    :hospital_weekday,
    :carer_weeknight,
    :hospital_weeknight,
    :carer_weekend,
    :hospital_weekend,
    :carer_weekend_night,
    :hospital_weekend_night,
    :carer_bank_holiday,
    :hospital_bank_holiday,       
  ].freeze

  # Overwrite this method to customize how rates are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(rate)
     "#{rate.zone}-#{rate.role}-#{rate.speciality}-#{rate.amount}"
  end
end
