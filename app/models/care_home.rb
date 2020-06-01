class CareHome < ApplicationRecord

  acts_as_paranoid
  after_save ThinkingSphinx::RealTime.callback_for(:care_home)

  has_many :users
  has_many :staffing_requests
  has_many :care_home_carer_mappings
  has_many :carers, :through => :care_home_carer_mappings, source: :user

  validates_presence_of :name, :postcode
  validates_presence_of :zone, if: :verified

  has_many :ratings, as: :rated_entity

  ZONES = ["North", "South", "London", "South East", "South West", "Midlands", "North West", "North East"]

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
  end

  after_save :update_coordinates
  def update_coordinates
    if(self.postcode_changed? && Rails.env != "test")
      GeocodeJob.perform_later(self)
    end
  end


  before_save :check_accept_bank_transactions
  def check_accept_bank_transactions
    if(self.accept_bank_transactions && self.accept_bank_transactions_changed?)
      self.accept_bank_transactions_date = Time.now
    end
  end

  # for testing only in factories - do not use in prod
  def postcodelatlng=(postcodelatlng)
    self.postcode = postcodelatlng.postcode
    self.lat = postcodelatlng.latitude
    self.lng = postcodelatlng.longitude
  end

  def new_qr_code
    self.qr_code = rand(7 ** 7)
    self.save
    UserNotifierMailer.care_home_qr_code(self).deliver_later
  end


  def emails
    list = self.users.collect(&:email).join(",")
    if(self.care_home_broadcast_group)
      list += "," + self.care_home_broadcast_group
    end
    list
  end

end
