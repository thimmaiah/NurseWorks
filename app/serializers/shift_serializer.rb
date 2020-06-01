class ShiftSerializer < ActiveModel::Serializer
  attributes :id, :staffing_request_id, :user_id, :start_code, :start_date, 
  :end_code, :end_date, :response_status, :minutes_worked, :care_home_base, :care_home_total_amount, :markup, 
  :vat, :carer_base, :viewed,
  :accepted, :rated, :care_home_rated, :user, :ratings, :care_home_id, :care_home, :staffing_request, 
  :payment, :payment_status, :care_home_payment_status, :can_manage, :reason

  belongs_to :user, serializer: UserMiniSerializer
  has_many :ratings, serializer: RatingSerializer
  belongs_to :staffing_request, serializer: StaffingRequestSerializer
  
  
  def can_manage
  	Ability.new(scope).can?(:manage, object)
  end


end
