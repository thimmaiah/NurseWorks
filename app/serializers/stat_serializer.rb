class StatSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :value
end
