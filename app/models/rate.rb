class Rate < ApplicationRecord

  validates_presence_of :carer_weekday, :care_home_weekday, :carer_weeknight, :care_home_weeknight, 
  						:carer_weekend, :care_home_weekend, :carer_weekend_night, :care_home_weekend_night, 
  						:carer_bank_holiday, :care_home_bank_holiday
  
  belongs_to :care_home
  
  class << self
    include RatesHelper
  end

end
