class RateSerializer < ActiveModel::Serializer
  attributes :id, :zone, :role, :speciality, :amount
end
