class Rate < ApplicationRecord

  validates_presence_of :nurse_weekday, :hospital_weekday, :nurse_weeknight, :hospital_weeknight, 
  						:nurse_weekend, :hospital_weekend, :nurse_weekend_night, :hospital_weekend_night, 
  						:nurse_bank_holiday, :hospital_bank_holiday
  
  belongs_to :hospital
  
  class << self
    include RatesHelper
  end

end
