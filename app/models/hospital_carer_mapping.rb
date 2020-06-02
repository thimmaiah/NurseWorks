class HospitalCarerMapping < ApplicationRecord
	belongs_to :hospital
	belongs_to :user	


	before_save :compute_distance
	before_save :set_defaults

	scope :enabled, -> { where enabled: true }
	scope :preferred, -> { where preferred: true }
	

	def set_defaults
		self.enabled = false if self.enabled == nil
		self.preferred = false if self.preferred == nil
	end

	def compute_distance
		self.distance = self.user.distance_from(self.hospital) if self.user
	end

	def self.populate_carers_from_history
			Shift.closed.each do |s|
			exiting = HospitalCarerMapping.where(hospital_id: s.hospital_id, user_id: s.user_id).first
			if exiting == nil
				ccm = HospitalCarerMapping.create(hospital_id: s.hospital_id, user_id: s.user_id, 
					                              enabled: true, preferred: false) 
				Rails.logger.debug "Creating HospitalCarerMapping from history #{ccm.id}"
			end
		end

	end

end
