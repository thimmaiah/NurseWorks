require "administrate/base_dashboard"

class ReferenceDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    first_name: Field::String,
    last_name: Field::String,
    title: Field::String,
    email: Field::String,
    address: Field::Text,
    email_sent_count: Field::Number,
    ref_type: Field::Select.with_options(collection: Reference::TYPES),
    user_id: Field::Number,
    user: Field::BelongsToSearch,
    reference_received: Field::BooleanToYesNo,
    received_on: Field::DateTime,

    notes: Field::Text,
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
    :first_name,
    :last_name,
    :ref_type,  
    :reference_received,
    :user,
    :email_sent_count
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :first_name,
    :last_name,
    :email,
    :address,
    :ref_type,
    :user,
    :email_sent_count,
    :reference_received,
    :received_on,
    :notes,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :first_name,
    :last_name,
    :email,
    :address,
    :ref_type,
    :user,
    :reference_received,
    :received_on,
    :notes,
    
  ].freeze

  # Overwrite this method to customize how references are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(reference)
  #   "Reference ##{reference.id}"
  # end
end
