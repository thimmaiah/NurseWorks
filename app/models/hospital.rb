class Hospital < ApplicationRecord

  acts_as_paranoid
  after_save ThinkingSphinx::RealTime.callback_for(:hospital)
  after_save :update_coordinates 
  
  has_many :users
  has_many :perm_nurses, -> { where("role =?", "Nurse") }, class_name: "User"
  has_many :staffing_requests
  has_many :hospital_nurse_mappings
  has_many :temp_nurses, -> { where("hospital_nurse_mappings.enabled =?", true) }, :through => :hospital_nurse_mappings, source: :user

  validates_presence_of :name, :city, :num_of_beds, :nurse_count
  validates_presence_of :city, if: :verified
  serialize :specializations, Array
  serialize :nurse_qualification_pct, Hash

  has_many :ratings, as: :rated_entity

  ZONES = ["North", "South", "East", "West", "Central"]
  SPECIALIZATION = ["Multi specialty", "Singe Specialty", "Obstetrics and Gynaecology", "General Surgery", "Pediatrics", "Opthalmology"]
  
  scope :verified, -> { where verified: true }
  scope :unverified, -> { where verified: false }
  
  # This is for geocoding the lat/lng from the address entered by the user.
  # The lst/lng is used to find distance from hospital
  def addr
    [address, city, "India"].compact.join(', ')
  end
  geocoded_by :addr, latitude: :lat, longitude: :lng  # ActiveRecord

  def update_coordinates
    if( Rails.env != "test" && id.present? &&  
        (saved_change_to_attribute?(:address) || saved_change_to_attribute?(:city)) )
      GeocodeJob.perform_later(self)
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
    self.phone = self.phone.gsub(/\s+/, "") if self.phone
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
