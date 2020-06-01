class CqcRecordSerializer < ActiveModel::Serializer
  attributes :id, :name, :aka, :address, :postcode, :phone, :website, :service_types, :services, :local_authority, :region, :cqc_url, :cqc_location
end
