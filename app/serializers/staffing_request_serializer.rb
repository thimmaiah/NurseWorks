class StaffingRequestSerializer < ActiveModel::Serializer
  
  attributes :id, :hospital_id, :user_id, :start_date, :end_date, :shift_duration, :rate_per_hour, :role, :speciality,
  :request_status, :auto_deny_in, :response_count, :payment_status, :user, :hospital, 
  :broadcast_status, :can_manage, :start_code, :end_code, :carer_base, :hospital_base, 
  :hospital_total_amount, :vat, :created_at, :updated_at, :notes, :reason, :po_for_invoice

  attribute :accepted_shift, serializer: ShiftMiniSerializer

  belongs_to :user, serializer: UserMiniSerializer
  belongs_to :hospital, serializer: HospitalMiniSerializer
  

  def can_manage
  	ability = Ability.new(scope)
  	ability.can?(:manage, object)
  end

end
