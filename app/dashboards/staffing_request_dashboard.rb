require "administrate/base_dashboard"

class StaffingRequestDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    hospital: Field::BelongsToSearch,
    recurring_request: Field::BelongsTo,
    manual_assignment_flag: Field::BooleanToYesNo,
    user: Field::BelongsToSearch,
    shifts: Field::HasMany.with_options(
      sort_by: 'start_date',
      direction: 'desc',
    ),
    po_for_invoice: Field::String, 
    assigned_shift: Field::HasOne.with_options(class_name: "Shift"),
    payment: Field::HasOne,
    id: Field::Number,
    carer_break_mins: Field::Number,
    hospital_id: Field::Number,
    user_id: Field::Number,
    preferred_carer_id: Field::Number,
    start_date: Field::DateTime,
    end_date: Field::DateTime,
    shift_duration: Field::Number,
    role: Field::Select.with_options(collection: User::ROLE), 
    speciality: Field::Select.with_options(collection: User::SPECIALIZATIONS),
    hospital_base: Field::Number.with_options(decimals: 2),
    hospital_total_amount: Field::Number.with_options(decimals: 2),
    vat: Field::Number.with_options(decimals: 2),
    pricing_audit: HashField, 
    select_user_audit: HashField, 
    request_status: Field::Select.with_options(collection: StaffingRequest::REQ_STATUS),
    auto_deny_in: Field::Number.with_options(decimals: 2),
    response_count: Field::Number,
    shift_status: Field::Select.with_options(collection: StaffingRequest::SHIFT_STATUS),
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    start_code: Field::String,
    end_code: Field::String,
    notes: Field::String,
    reason: Field::String,
    broadcast_status: Field::Select.with_options(collection: StaffingRequest::BROADCAST_STATUS),
    versions: VersionField
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :hospital,
    :user,
    :start_date,
    :shift_duration,
    :end_date,
    :hospital_total_amount,
    :manual_assignment_flag,
    :request_status,
    :shift_status,
    :broadcast_status,
    :assigned_shift
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :hospital,
    :user,
    :role,
    :speciality,
    :start_date,
    :shift_duration,
    :end_date,
    :start_code,
    :end_code,
    :request_status,
    :preferred_carer_id,
    :shifts,
    :payment,
    :po_for_invoice,
    :carer_break_mins,
    :manual_assignment_flag,
    :notes,
    :reason,
    :hospital_total_amount,
    :hospital_base,
    :vat,    
    :auto_deny_in,
    :response_count,
    :shift_status,
    :created_at,
    :updated_at,
    :broadcast_status,
    :recurring_request,
    :select_user_audit,
    :pricing_audit,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :start_date,
    :shift_duration,
    :end_date,
    :manual_assignment_flag,
    :role,
    :speciality,
    :carer_break_mins,
    :request_status,
    :po_for_invoice,
    :hospital,
    :user,
    :start_code,
    :end_code,
    :notes
  ].freeze

  # Overwrite this method to customize how staffing requests are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(staffing_request)
  #   "StaffingRequest ##{staffing_request.id}"
  # end
end
