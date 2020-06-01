class PaymentSerializer < ActiveModel::Serializer
  attributes :id, :shift_id, :user_id, :care_home_id, 
  :paid_by_id, :amount, :vat, :markup, :care_giver_amount, :billing,
  :notes, :user, :care_home, :staffing_request_id, :staffing_request, :shift

  belongs_to :shift, serializer: ShiftMiniSerializer
  belongs_to :staffing_request, serializer: StaffingRequestSerializer
  
end
