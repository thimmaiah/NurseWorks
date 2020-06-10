require "administrate/base_dashboard"

class ShiftDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    user: Field::BelongsToSearch,
    staffing_request: Field::BelongsTo.with_options(
      sort_by: 'start_date',
      direction: 'desc',
    ),
    hospital: Field::BelongsToSearch,
    payment: Field::HasOne,
    nurse_base: Field::Number.with_options(decimals: 2),
    hospital_total_amount: Field::Number.with_options(decimals: 2),
    hospital_base: Field::Number.with_options(decimals: 2),
    markup: Field::Number.with_options(decimals: 2),
    vat: Field::Number.with_options(decimals: 2),
    ratings: Field::HasMany,
    id: Field::Number,
    manual_close: Field::BooleanToYesNo,
    preferred_care_giver_selected: Field::BooleanToYesNo, 
    start_code: Field::String,
    end_code: Field::String,
    start_date: Field::DateTime,
    end_date: Field::DateTime,
    nurse_break_mins: Field::Number,
    response_status: Field::Select.with_options(collection: Shift::RESPONSE_STATUS),
    accepted: Field::BooleanToYesNo,
    rated: Field::BooleanToYesNo,
    pricing_audit: HashField, 
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    payment_status: Field::Select.with_options(collection: Shift::PAYMENT_STATUS),
    hospital_payment_status: Field::Select.with_options(collection: Shift::PAYMENT_STATUS),
    versions: VersionField,
    reason: Field::String
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
    :start_date,
    :end_date,
    :response_status,
    :manual_close,
    :preferred_care_giver_selected,
    :rated,
    :hospital_total_amount
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :user,
    :staffing_request,
    :hospital,
    :nurse_break_mins,
    :payment,
    :hospital_base,
    :vat,
    :hospital_total_amount,
    :markup,
    :nurse_base,        
    :ratings,
    :id,
    :manual_close,
    :preferred_care_giver_selected,
    :start_code,
    :end_code,
    :start_date,
    :end_date,
    :response_status,
    :reason,
    :pricing_audit,
    :accepted,
    :rated,
    :created_at,
    :updated_at,
    :payment_status,
    :hospital_payment_status,
    :versions
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :start_date,
    :end_date,
    :start_code,
    :end_code,
    :nurse_break_mins,
    :manual_close,
  ].freeze

  # Overwrite this method to customize how staffing responses are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(shift)
    "Shift ##{shift.id}: #{shift.user.first_name}: #{shift.response_status}"
  end
end
