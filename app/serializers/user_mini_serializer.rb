class UserMiniSerializer < ActiveModel::Serializer
  attributes :id, :title, :first_name, :last_name, :email, :role, :phone, :phone_verified, :speciality,
    :postcode, :address, :image, :rating, :can_manage

  def can_manage
    Ability.new(scope).can?(:manage, object)
  end

  def rating
    (object.rating_count > 0) ? (object.total_rating/object.rating_count) : 0
  end

end
