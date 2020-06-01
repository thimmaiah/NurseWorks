require "administrate/base_dashboard"

class UserDocDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    user_id: Field::Number,
    created_by_id: Field::Number,
    created_by: Field::BelongsTo,
    training_id: Field::Number,
    training: Field::BelongsToSearch,
    name: Field::String,
    doc_type: Field::Select.with_options(collection: UserDoc::DOC_TYPES),
    alt_doc_type: Field::String,
    user: Field::BelongsToSearch,
    expiry_date: Field::DateTime,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    doc_file_name: Field::String,
    doc_content_type: Field::String,
    doc_file_size: Field::Number,
    doc_updated_at: Field::DateTime,
    verified: Field::BooleanToYesNo,
    not_available: Field::BooleanToYesNo,
    notes: Field::Text,
    doc: PaperclipField
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :name,
    :doc_type,
    :user,
    :expiry_date,
    :verified,
    :not_available
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :name,
    :doc_type,
    :alt_doc_type,
    :expiry_date,
    :training,
    :user,
    :created_at,
    :updated_at,
    :doc_file_name,
    :verified,
    :not_available,
    :notes,
    :doc
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :name,
    :user,
    :training,
    :doc_type,
    :alt_doc_type,
    :expiry_date,
    :verified,
    :not_available,
    :doc
  ].freeze

  # Overwrite this method to customize how user docs are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(user_doc)
  #   "UserDoc ##{user_doc.id}"
  # end
end
