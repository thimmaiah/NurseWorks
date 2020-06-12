class ShiftSerializer < ActiveModel::Serializer
  attributes :id, :staffing_request_id, :user_id, :start_code, :start_date, 
  :end_code, :end_date, :response_status, :minutes_worked, :hospital_base, :hospital_total_amount, 
  :markup, :vat, :nurse_base, :viewed,
  :accepted, :rated, :hospital_rated, :user, :ratings, :hospital_id, :hospital, :staffing_request, 
  :payment, :payment_status, :hospital_payment_status, :can_manage, :reason, 
  :start_signature_id, :end_signature_id

  belongs_to :user, serializer: UserMiniSerializer
  has_many :ratings, serializer: RatingSerializer
  belongs_to :staffing_request, serializer: StaffingRequestSerializer
  
  
  def can_manage
  	Ability.new(scope).can?(:manage, object)
  end


end
