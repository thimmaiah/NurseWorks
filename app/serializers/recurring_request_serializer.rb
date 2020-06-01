class RecurringRequestSerializer < ActiveModel::Serializer
  attributes :id, :care_home_id, :user_id, :start_date, :end_date, :role, :speciality, 
             :care_home, :user, :dates, :created_at, :po_for_invoice

  belongs_to :user, serializer: UserMiniSerializer
  belongs_to :care_home, serializer: CareHomeMiniSerializer
end
