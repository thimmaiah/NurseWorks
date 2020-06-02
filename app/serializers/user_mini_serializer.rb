class UserMiniSerializer < ActiveModel::Serializer
  attributes :id, :title, :first_name, :last_name, :email, :role, :phone, :phone_verified, :specializations,
    :postcode, :address, :image, :rating, :can_manage, :age, :years_of_exp, :months_of_exp, 
    :key_qualifications, :locum, :conveyence

  def can_manage
    Ability.new(scope).can?(:manage, object)
  end

  def rating
    (object.rating_count > 0) ? (object.total_rating/object.rating_count) : 0
  end

end
