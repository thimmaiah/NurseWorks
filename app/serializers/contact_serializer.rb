class ContactSerializer < ActiveModel::Serializer
  attributes :id, :name, :phone, :email, :relationship, :user_id, :contact_type
end
