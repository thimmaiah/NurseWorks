class LessonSerializer < ActiveModel::Serializer
  attributes :id, :title, :link, :link_type, :description, :min_nq_score, :max_nq_score, :quiz_id
end
