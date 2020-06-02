class PaymentSerializer < ActiveModel::Serializer
  attributes :id, :shift_id, :user_id, :hospital_id, 
  :paid_by_id, :amount, :vat, :markup, :care_giver_amount, :billing,
  :notes, :user, :hospital, :staffing_request_id, :staffing_request, :shift

  belongs_to :shift, serializer: ShiftMiniSerializer
  belongs_to :staffing_request, serializer: StaffingRequestSerializer
  
end
