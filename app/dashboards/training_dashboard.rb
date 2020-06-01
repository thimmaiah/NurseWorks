require "administrate/base_dashboard"

class TrainingDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    user: Field::BelongsToSearch,
    profile: Field::BelongsTo,
    id: Field::Number,
    name: Field::String,
    undertaken: Field::BooleanToYesNo,
    date_completed: Field::DateTime,
    profile_id: Field::Number,
    user_id: Field::Number,
    expiry_date: Field::DateTime,
    vendor: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :name,
    :vendor,
    :undertaken,
    :date_completed,
    :expiry_date
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :name,
    :vendor,
    :undertaken,
    :date_completed,
    :expiry_date,
    :profile,
    :user,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :profile_id,
    :user,
    :name,
    :vendor,
    :undertaken,
    :date_completed,
    :expiry_date
  ].freeze

  # Overwrite this method to customize how trainings are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(training)
    "{training.name}"
  end
end
