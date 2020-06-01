require 'csv'
class CqcRecord < ApplicationRecord

  after_save ThinkingSphinx::RealTime.callback_for(:user)


  def self.load(csv_file)
    csv_text = File.read(csv_file)
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      i=0
      puts row[0]
      CqcRecord.create(name: row[0],
                       aka: row[1],
                       address: row[2],
                       postcode: row[3],
                       phone: row[4],
                       website: row[5],
                       service_types: row[6],
                       services: row[8],
                       local_authority: row[10],
                       region: row[11],
                       cqc_url: row[12],
                       cqc_location: row[13])
    end
  end
  
end
