class ReferralSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :role, :user_id
end
