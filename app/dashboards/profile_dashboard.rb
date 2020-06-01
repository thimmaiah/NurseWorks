require "administrate/base_dashboard"

class ProfileDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    user: Field::BelongsToSearch,
    trainings: Field::HasMany,
    id: Field::Number,
    user_id: Field::Number,
    date_of_CRB_DBS_check: Field::DateTime,
    dob: Field::DateTime,
    pin: Field::String,
    enhanced_crb: Field::BooleanToYesNo,
    crd_dbs_returned: Field::BooleanToYesNo,
    isa_returned: Field::BooleanToYesNo,
    crd_dbs_number: Field::String,
    eligible_to_work_UK: Field::BooleanToYesNo,
    confirmation_of_identity: Field::BooleanToYesNo,
    references_received: Field::DateTime,
    dl_passport: Field::BooleanToYesNo,
    all_required_paperwork_checked: Field::BooleanToYesNo,
    registered_under_disability_act: Field::BooleanToYesNo,
    connuct_policies: Field::BooleanToYesNo,
    form_completed_by: Field::String,
    position: Field::String,
    date_sent: Field::DateTime,
    date_received: Field::DateTime,
    known_as: Field::String,
    role: Field::String,
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
    :position,
    :date_sent,
    :date_received,
    :form_completed_by,
    
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :user,
    :date_of_CRB_DBS_check,
    :dob,
    :pin,
    :enhanced_crb,
    :crd_dbs_returned,
    :isa_returned,
    :crd_dbs_number,
    :eligible_to_work_UK,
    :confirmation_of_identity,
    :references_received,
    :dl_passport,
    :all_required_paperwork_checked,
    :registered_under_disability_act,
    :connuct_policies,
    :form_completed_by,
    :position,
    :date_sent,
    :date_received,
    :known_as,
    :role,
    :trainings
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :user,
    :date_of_CRB_DBS_check,
    :dob,
    :pin,
    :enhanced_crb,
    :crd_dbs_returned,
    :isa_returned,
    :crd_dbs_number,
    :eligible_to_work_UK,
    :confirmation_of_identity,
    :references_received,
    :dl_passport,
    :all_required_paperwork_checked,
    :registered_under_disability_act,
    :connuct_policies,
    :form_completed_by,
    :position,
    :date_sent,
    :date_received,
    :known_as,
    :role,
  ].freeze

  # Overwrite this method to customize how profiles are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(profile)
  #   "Profile ##{profile.id}"
  # end
end
