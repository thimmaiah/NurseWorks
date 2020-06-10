class StaffingRequestMiniSerializer < ActiveModel::Serializer
  
  attributes :id, :hospital_id, :user_id, :start_date, :end_date, :shift_duration, :rate_per_hour, :role, :speciality,
  :request_status, :auto_deny_in, :response_count, :payment_status, :user_id, :hospital, 
  :broadcast_status, :can_manage, :start_code, :end_code, :carer_base, :hospital_base, 
  :hospital_total_amount, :vat, :created_at, :updated_at, :notes, :reason, :po_for_invoice,
  :staff_type

  belongs_to :hospital, serializer: HospitalMiniSerializer

  def can_manage
  	ability = Ability.new(scope)
  	ability.can?(:manage, object)
  end

  # We need to always send Lon dates back - as the time should be Lon time
  def start_date
  	object.start_date.strftime("%Y-%m-%dT%H:%M")
  end

  def end_date
  	object.end_date.strftime("%Y-%m-%dT%H:%M")
  end

  def created_at
    object.created_at.strftime("%Y-%m-%dT%H:%M")
  end

end
