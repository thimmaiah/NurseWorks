class TrainingSerializer < ActiveModel::Serializer
  attributes :id, :name, :undertaken, :date_completed, :profile_id, :user_id
end
