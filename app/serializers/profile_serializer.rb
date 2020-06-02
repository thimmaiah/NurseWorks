class ProfileSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :date_of_CRB_DBS_check, :dob, :pin, :enhanced_crb, 
  :crd_dbs_returned, :isa_returned, :crd_dbs_number, :eligible_to_work_UK, 
  :confirmation_of_identity, :references_received, :dl_passport, 
  :all_required_paperwork_checked, :registered_under_disability_act, 
  :nurse_works_policies, :form_completed_by, :position, :date_sent, :date_received, :known_as, :role

end
