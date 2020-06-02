require "administrate/base_dashboard"

class PaymentDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    user: Field::BelongsToSearch,
    hospital: Field::BelongsToSearch,
    shift: Field::BelongsTo,
    staffing_request: Field::BelongsTo,
    paid_by: Field::BelongsToSearch.with_options(class_name: "User"),
    paid_by_id: Field::Number,
    amount: Field::Number.with_options(decimals: 2),
    billing: Field::Number.with_options(decimals: 2),
    vat: Field::Number.with_options(decimals: 2),
    markup: Field::Number.with_options(decimals: 2),
    care_giver_amount: Field::Number.with_options(decimals: 2),
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
    :user,
    :hospital,    
    :staffing_request,
    :billing,
    :vat,
    :amount,
    :care_giver_amount,    
    :markup,    
    :notes
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :user,
    :hospital,
    :shift,
    :staffing_request,
    :paid_by,
    :id,
    :billing,
    :vat,    
    :amount,        
    :care_giver_amount,
    :markup,
    :notes,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :amount,    
    :user,
    :care_giver_amount,
    :vat,
    :markup,
    :billing,
    :notes,
  ].freeze

  # Overwrite this method to customize how payments are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(payment)
  #   "Payment ##{payment.id}"
  # end
end
