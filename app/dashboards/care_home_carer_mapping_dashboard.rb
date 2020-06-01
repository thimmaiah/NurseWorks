require "administrate/base_dashboard"

class CareHomeCarerMappingDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    care_home: Field::BelongsToSearch,
    user: Field::BelongsToSearch,
    enabled: Field::BooleanToYesNo,
    preferred: Field::BooleanToYesNo,
    distance: Field::Number.with_options(decimals: 2),
    manually_created: Field::BooleanToYesNo,
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
    :care_home,
    :user,
    :distance,
    :enabled,
    :preferred
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :care_home,
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
    :care_home,
    :user,
    :preferred,
    :enabled,
    :distance,
    :manually_created
  ].freeze

  # Overwrite this method to customize how care home carer mappings are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(care_home_carer_mapping)
  #   "CareHomeCarerMapping ##{care_home_carer_mapping.id}"
  # end
end
