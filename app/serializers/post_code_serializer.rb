class PostCodeSerializer < ActiveModel::Serializer
  attributes :id, :postcode, :latitude, :longitude
end
