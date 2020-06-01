require "administrate/base_dashboard"

class StatDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    name: Field::String,
    description: Field::String,
    value: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    as_of_date: Field::DateTime,
    date_range: Field::String,
    stat_type: Field::String,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :name,
    :date_range,
    :value,
    :as_of_date,
    :stat_type,    
    :description,
    :id,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    
    :name,
    :as_of_date,
    :date_range,    
    :value,
    :stat_type,
    :description,
    :created_at,
    :updated_at,
    :id,
    
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :name,
    :stat_type,
    :description,
    :value,
    :as_of_date,
    :date_range,
  ].freeze

  # Overwrite this method to customize how stats are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(stat)
  #   "Stat ##{stat.id}"
  # end
end
