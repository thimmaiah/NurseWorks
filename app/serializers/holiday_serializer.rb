class HolidaySerializer < ActiveModel::Serializer
  attributes :id, :name, :date, :bank_holiday
end
