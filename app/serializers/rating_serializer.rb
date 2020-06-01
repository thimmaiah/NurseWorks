class RatingSerializer < ActiveModel::Serializer
  attributes :id, :rated_entity_type, :rated_entity_id, :rated_entity, 
  :care_home, :created_by_id, :shift_id, :stars, :comments
end
