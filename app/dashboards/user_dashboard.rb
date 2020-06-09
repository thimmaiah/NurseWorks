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
    hospital_carer_mappings: Field::HasMany,
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
    pref_commute_distance: Field::Select.with_options(collection: User::COMMUTE_DISTANCE),
    occupation: Field::String,
    specializations: CheckboxList.with_options(choices: User::SPECIALIZATIONS),
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
    nursing_school_name: Field::String,
    NUID: Field::String,
    nuid_valid: Field::BooleanToYesNo,
    nq_score: Field::Number,
    nq_score_base: Field::Number, 
    nq_score_dynamic: Field::Number, 
    nq_score_normalized: Field::Number, 
    
    bank_account: Field::String,
    ready_for_verification: Field::BooleanToYesNo,
    phone_verified: Field::BooleanToYesNo,
    city: Field::String,
    created_at: Field::DateTime,
    auto_selected_date: Field::DateTime,
    age: Field::Number, 
    years_of_exp: Field::Number, 
    months_of_exp: Field::Number, 
    key_qualifications: Field::Select.with_options(collection: User::QUALIFICATIONS), 
    avail_part_time: Field::BooleanToYesNo, 
    avail_full_time: Field::BooleanToYesNo, 
    public_profile: Field::BooleanToYesNo,   
    head_nurse: Field::BooleanToYesNo,
    conveyence: Field::Select.with_options(collection: User::CONVEYENCE),
    pref_shift_duration: Field::Select.with_options(collection: User::SHIFT_DURATION),
    pref_shift_time: Field::Select.with_options(collection: User::SHIFT_TIME), 
    exp_shift_rate: Field::Select.with_options(collection: User::SHIFT_RATE),
    
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
    :avail_part_time,
    :avail_full_time,
    :public_profile,
    :ready_for_verification,
    :phone_verified,
    :role,
    :hospital,
    :specializations,
    :pref_commute_distance,
    
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :user_docs,    
    :ready_for_verification,
    :phone_verified,
    :id,
    :first_name,
    :last_name,
    :email,
    :phone,
    :role,
    :hospital,
    :specializations,
    :sex,
    :age, 
    :head_nurse,
    :years_of_exp, 
    :months_of_exp, 
    :key_qualifications, 
    :public_profile,
    :avail_full_time,    
    :avail_part_time,     
    :pref_shift_duration, 
    :pref_shift_time, 
    :exp_shift_rate,
    :conveyence,
    :pref_commute_distance,
    :nursing_school_name,
    :NUID,
    :nuid_valid,    
    :nq_score,
    :nq_score_base,
    :nq_score_dynamic,
    :nq_score_normalized,    
    :bank_account,
    :active,
    :work_weekdays,
    :work_weeknights,
    :work_weekends,
    :work_weekend_nights,
    :pause_shifts,
    :address,
    :city,
    :rating,
    :medical_info,    
    :hospital_carer_mappings,
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
    :age, 
    :head_nurse,
    :years_of_exp, 
    :months_of_exp, 
    :key_qualifications,
    :public_profile,
    :avail_full_time,     
    :avail_part_time,     
    :pref_shift_duration, 
    :pref_shift_time, 
    :exp_shift_rate,
    :conveyence,
    :pref_commute_distance,
    :image_url,
    :nursing_school_name,
    :NUID,
    :nuid_valid,
    :bank_account,
    :active,
    :work_weekdays,
    :work_weeknights,
    :work_weekends,
    :work_weekend_nights,
    :pause_shifts,
    :address,
    :city,
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
