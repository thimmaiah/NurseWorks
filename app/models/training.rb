class Training < ApplicationRecord

	belongs_to :user
	belongs_to :profile

	validates_presence_of :user_id, :profile, :name, :date_completed

	TRAINING_CERTIFICATES = [	"Manual Handling",
								"Health & Safety",
								"Infection Control",
								"Medication Administration",
								"Safeguarding of Vulnerable Adults",
								"Basic Life Support",
								"First Aid",
								"Equality & Diversity",
								"Fire Safety",
								"Information Governance (for Nurses only)",
								"Food Hygiene" ]
end
