class CareHomeMiniSerializer < ActiveModel::Serializer
  attributes :id, :name, :address, :town, :postcode, :phone,:qr_code
    
end
