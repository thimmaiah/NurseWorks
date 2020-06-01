require "administrate/base_dashboard"

class RatingDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    shift: Field::BelongsTo,
    rated_entity: Field::Polymorphic,
    care_home: Field::BelongsTo,
    created_by: Field::BelongsTo.with_options(class_name: "User"),
    id: Field::Number,
    stars: Field::Number,
    comments: Field::Text,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    created_by_id: Field::Number,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :shift,
    :rated_entity,
    :care_home,
    :stars,
    :comments
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :shift,
    :rated_entity,
    :care_home,
    :created_by,
    :id,
    :stars,
    :comments,
    :created_at,
    :updated_at,
    :created_by_id,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :stars,
    :comments
  ].freeze

  # Overwrite this method to customize how ratings are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(rating)
  #   "Rating ##{rating.id}"
  # end
end
