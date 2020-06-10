class HospitalNurseMappingSerializer < ActiveModel::Serializer
  attributes :id, :hospital_id, :user_id, :enabled, :distance, :manually_created
end
