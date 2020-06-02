class Rate < ApplicationRecord

  validates_presence_of :carer_weekday, :hospital_weekday, :carer_weeknight, :hospital_weeknight, 
  						:carer_weekend, :hospital_weekend, :carer_weekend_night, :hospital_weekend_night, 
  						:carer_bank_holiday, :hospital_bank_holiday
  
  belongs_to :hospital
  
  class << self
    include RatesHelper
  end

end
