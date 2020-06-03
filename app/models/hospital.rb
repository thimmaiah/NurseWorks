class Hospital < ApplicationRecord

  acts_as_paranoid
  after_save ThinkingSphinx::RealTime.callback_for(:hospital)

  has_many :users
  has_many :staffing_requests
  has_many :hospital_carer_mappings
  has_many :carers, :through => :hospital_carer_mappings, source: :user

  validates_presence_of :name, :city, :num_of_beds, :nurse_count
  validates_presence_of :zone, if: :verified
  serialize :specializations, Array
  serialize :nurse_qualification_pct, Hash

  has_many :ratings, as: :rated_entity

  ZONES = ["North", "South", "London", "South East", "South West", "Midlands", "North West", "North East"]
  SPECIALIZATION = ["Multi specialty", "Singe Specialty", "Obstetrics and Gynaecology", "General Surgery", "Pediatrics", "Opthalmology"]
  scope :verified, -> { where verified: true }
  scope :unverified, -> { where verified: false }
  
  reverse_geocoded_by :lat, :lng do |obj,results|
    if geo = results.first
      obj.address = geo.address.sub(geo.city + ", ", '').sub(geo.postal_code + ", ", '').sub("UK", '') if !obj.address
      obj.town    = geo.city if !obj.town
    end
  end

  def latitude_in_radians
    Math::PI * lat / 180.0 if lat
  end

  def longitude_in_radians
    Math::PI * lng / 180.0 if lng
  end

  before_create :set_defaults
  def set_defaults
    self.verified = false if verified == nil
    self.image_url = "assets/icon/homecare.png"
    self.total_rating = 0
    self.rating_count = 0
    # Remove all whitespace from the phone
    self.phone = self.phone.gsub(/\s+/, "") 
    self.specializations = [] if self.specializations == nil
    self.nurse_qualification_pct = {} if self.nurse_qualification_pct == nil
  end

  # after_save :update_coordinates
  # def update_coordinates
  #   if(self.postcode_changed? && Rails.env != "test")
  #     GeocodeJob.perform_later(self)
  #   end
  # end


  def emails
    list = self.users.collect(&:email).join(",")
    if(self.hospital_broadcast_group)
      list += "," + self.hospital_broadcast_group
    end
    list
  end

end
