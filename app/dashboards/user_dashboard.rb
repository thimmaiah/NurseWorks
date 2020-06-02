require "administrate/base_dashboard"

class UserDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    hospital: Field::BelongsToSearch,
    user_docs: Field::HasMany,
    profile: Field::HasOne,
    shifts: Field::HasMany,
    versions: VersionField,
    id: Field::Number,
    rating: Field::Number,
    first_name: Field::String,
    last_name: Field::String,
    email: Field::String,
    password: Field::String,
    password_confirmation: Field::String,
    role: Field::Select.with_options(collection: User::ROLE),
    nurse_type: Field::String,
    sex: Field::Select.with_options(collection: User::SEX),
    phone: Field::String,
    address: Field::Text,
    languages: Field::String,
    pref_commute_distance: Field::Number,
    occupation: Field::String,
    specializations: CheckboxList.with_options(choices: User::SPECIALITY),
    experience: Field::Number,
    accept_terms: Field::BooleanToYesNo,
    
    active: Field::BooleanToYesNo,
    work_weekdays: Field::BooleanToYesNo,
    work_weeknights: Field::BooleanToYesNo,
    work_weekends: Field::BooleanToYesNo,
    work_weekend_nights: Field::BooleanToYesNo,
    pause_shifts: Field::BooleanToYesNo,
    
    medical_info: Field::Text,
    image_url: Field::Text,
    sort_code: Field::String,
    bank_account: Field::String,
    ready_for_verification: Field::BooleanToYesNo,
    phone_verified: Field::BooleanToYesNo,
    postcode: Field::String,
    created_at: Field::DateTime,
    auto_selected_date: Field::DateTime,
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
    :email,
    :ready_for_verification,
    :phone_verified,
    :role,
    :hospital,
    :specializations,
    :pref_commute_distance,
    :created_at
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :profile,
    :user_docs,    
    :ready_for_verification,
    :phone_verified,
    :id,
    :first_name,
    :last_name,
    :email,
    :role,
    :hospital,
    :specializations,
    :sex,
    :phone,
    :pref_commute_distance,
    :sort_code,
    :bank_account,
    :active,
    :work_weekdays,
    :work_weeknights,
    :work_weekends,
    :work_weekend_nights,
    :pause_shifts,
    :postcode,
    :rating,
    :medical_info,    
    :shifts

  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :phone_verified,
    :first_name,
    :last_name,
    :email,
    :role,
    :hospital,
    :specializations,
    :sex,
    :phone,
    :pref_commute_distance,
    :image_url,
    :sort_code,
    :bank_account,
    :active,
    :work_weekdays,
    :work_weeknights,
    :work_weekends,
    :work_weekend_nights,
    :pause_shifts,
    :postcode,
    :medical_info,
    :created_at
  ].freeze


  # Overwrite this method to customize how users are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(user)
    "#{user.first_name} #{user.last_name} #{user.id}"
  end

  def permitted_attributes
    super + [:password, :password_confirmation]
  end

end
