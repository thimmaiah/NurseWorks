class StaffingRequestSerializer < ActiveModel::Serializer
  
  attributes :id, :care_home_id, :user_id, :start_date, :end_date, :rate_per_hour, :role, :speciality,
  :request_status, :auto_deny_in, :response_count, :payment_status, :user, :care_home, 
  :broadcast_status, :can_manage, :start_code, :end_code, :carer_base, :care_home_base, 
  :care_home_total_amount, :vat, :created_at, :updated_at, :notes, :reason, :po_for_invoice

  attribute :accepted_shift, serializer: ShiftMiniSerializer

  belongs_to :user, serializer: UserMiniSerializer
  belongs_to :care_home, serializer: CareHomeMiniSerializer
  

  def can_manage
  	ability = Ability.new(scope)
  	ability.can?(:manage, object)
  end

end
