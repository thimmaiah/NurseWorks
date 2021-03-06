require "administrate/base_dashboard"

class HospitalNurseMappingDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    hospital: Field::BelongsToSearch,
    user: Field::BelongsToSearch,
    enabled: Field::BooleanToYesNo,
    preferred: Field::BooleanToYesNo,
    distance: Field::Number.with_options(decimals: 2),
    manually_created: Field::BooleanToYesNo,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    user_addr: Field::String,
    user_pref_commute_distance: Field::String, 
    hospital_addr: Field::String,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :hospital,
    :hospital_addr,
    :user,
    :user_addr,
    :user_pref_commute_distance,
    :distance,
    :enabled,
    :preferred
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :hospital,
    :user,
    :preferred,
    :enabled,
    :distance,
    :manually_created,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :user,
    :preferred,
    :enabled,
    :distance
  ].freeze

  # Overwrite this method to customize how care home nurse mappings are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(hospital_nurse_mapping)
  #   "HospitalNurseMapping ##{hospital_nurse_mapping.id}"
  # end
end
