class CareHomeCarerMappingSerializer < ActiveModel::Serializer
  attributes :id, :care_home_id, :user_id, :enabled, :distance, :manually_created
end
