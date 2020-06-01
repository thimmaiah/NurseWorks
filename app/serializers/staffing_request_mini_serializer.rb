class StaffingRequestMiniSerializer < ActiveModel::Serializer
  
  attributes :id, :care_home_id, :user_id, :start_date, :end_date, :rate_per_hour, :role, :speciality,
  :request_status, :auto_deny_in, :response_count, :payment_status, :user_id, :care_home, 
  :broadcast_status, :can_manage, :start_code, :end_code, :carer_base, :care_home_base, 
  :care_home_total_amount, :vat, :created_at, :updated_at, :notes, :reason, :po_for_invoice

  belongs_to :care_home, serializer: CareHomeMiniSerializer

  def can_manage
  	ability = Ability.new(scope)
  	ability.can?(:manage, object)
  end

  # We need to always send Lon dates back - as the time should be Lon time
  def start_date
  	object.start_date.in_time_zone("Europe/London").strftime("%Y-%m-%dT%H:%M")
  end

  def end_date
  	object.end_date.in_time_zone("Europe/London").strftime("%Y-%m-%dT%H:%M")
  end

  def created_at
    object.created_at.in_time_zone("Europe/London").strftime("%Y-%m-%dT%H:%M")
  end

end
