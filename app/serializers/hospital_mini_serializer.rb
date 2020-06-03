class HospitalMiniSerializer < ActiveModel::Serializer
  attributes :id, :name, :address, :city, :postcode, :phone
    
end
