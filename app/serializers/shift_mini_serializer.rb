class ShiftMiniSerializer < ActiveModel::Serializer
  attributes :id, :staffing_request_id, :user_id, :start_code, :start_date, 
  :end_code, :end_date, :response_status, :minutes_worked, :hospital_base, :hospital_total_amount, :markup, :viewed,
  :accepted, :rated, :hospital_rated, :user, :hospital, 
  :staffing_request, :payment_status, :hospital_payment_status, :can_manage

  belongs_to :user, serializer: UserMiniSerializer
  
  def can_manage
  	Ability.new(scope).can?(:manage, object)
  end

end
