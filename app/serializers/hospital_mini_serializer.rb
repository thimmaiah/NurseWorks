class HospitalMiniSerializer < ActiveModel::Serializer
  attributes :id, :name, :address, :town, :postcode, :phone
    
end
