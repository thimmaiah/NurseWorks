class LessonSerializer < ActiveModel::Serializer
  attributes :id, :title, :youtube_link, :description, :min_nq_score, :max_nq_score, :quiz_id
end
