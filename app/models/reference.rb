class Reference < ApplicationRecord
	TYPES = ["Current Employer", "Past Employer", "Character Reference"]
	belongs_to :user

	scope :not_received, -> {where("reference_received = ?", false)}

	before_create :set_defaults

	def set_defaults
		self.reference_received = false if self.reference_received == nil
		self.email_sent_count = 0 if self.email_sent_count == nil
	end
end
