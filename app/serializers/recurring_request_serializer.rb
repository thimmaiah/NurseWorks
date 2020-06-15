class RecurringRequestSerializer < ActiveModel::Serializer
  attributes :id, :hospital_id, :user_id, :start_date, :end_date, :role, :speciality, 
             :hospital, :user, :dates, :created_at, :po_for_invoice, 
             :shift_duration, :staff_type

  belongs_to :user, serializer: UserMiniSerializer
  belongs_to :preferred_nurse, serializer: UserMiniSerializer
  belongs_to :hospital, serializer: HospitalMiniSerializer
end
