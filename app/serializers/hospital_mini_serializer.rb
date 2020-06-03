class HospitalMiniSerializer < ActiveModel::Serializer
  attributes :id, :name, :address, :city, :phone
    
end
