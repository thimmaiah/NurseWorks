require "administrate/base_dashboard"

class LessonDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    title: Field::Text,
    link: Field::String,
    link_type: Field::Select.with_options(collection: Lesson::TYPES),   
    description: Field::Text,
    min_nq_score: Field::Number,
    max_nq_score: Field::Number,
    quiz_id: Field::Number,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    specializations: CheckboxList.with_options(choices: User::SPECIALIZATIONS),  
    key_qualifications: CheckboxList.with_options(choices: User::QUALIFICATIONS),
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
  id
  title
  key_qualifications
  link
  link_type
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
  id
  title
  key_qualifications
  specializations
  link
  link_type
  description
  min_nq_score
  max_nq_score
  quiz_id
  created_at
  updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
  title
  key_qualifications
  specializations
  link
  link_type
  description
  min_nq_score
  max_nq_score
  quiz_id
  ].freeze

  # COLLECTION_FILTERS
  # a hash that defines filters that can be used while searching via the search
  # field of the dashboard.
  #
  # For example to add an option to search for open resources by typing "open:"
  # in the search field:
  #
  #   COLLECTION_FILTERS = {
  #     open: ->(resources) { resources.where(open: true) }
  #   }.freeze
  COLLECTION_FILTERS = {}.freeze

  # Overwrite this method to customize how lessons are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(lesson)
  #   "Lesson ##{lesson.id}"
  # end
end
