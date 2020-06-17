class UserMiniSerializer < ActiveModel::Serializer
  attributes :id, :title, :first_name, :last_name, :email, :role, :phone,
     :avail_part_time, :avail_full_time, :currently_permanent_staff, :rating, :profile_pic

  has_one :profile_pic, serializer: UserDocSerializer

  def can_manage
    Ability.new(scope).can?(:manage, object)
  end

  def rating
    (object.rating_count > 0) ? (object.total_rating/object.rating_count) : 0
  end

end
