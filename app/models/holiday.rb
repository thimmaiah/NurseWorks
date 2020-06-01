require 'csv'
class Holiday < ApplicationRecord


  def self.load(csv_file)
    csv_text = File.read(csv_file)
    csv = CSV.parse(csv_text, :headers => false)
    csv.each do |row|
      i=0
      puts row[0]
      Holiday.create(date: Date.parse(row[0]),
                     name: row[2])
    end
  end

  def self.isHoliday?(date)
  	d = date.to_date
  	h = Holiday.where(date: d).first 
  	h != nil 
  end

  def self.isBankHoliday?(date)
  	d = date.to_date
  	h = Holiday.where(date: d).first 
  	h != nil && h.bank_holiday
  end

end
