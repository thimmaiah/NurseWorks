class ReferenceSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :title, :email, :ref_type, :user_id, :address
end
