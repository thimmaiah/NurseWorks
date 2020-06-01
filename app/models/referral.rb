class Referral < ApplicationRecord

	belongs_to :user
	after_save ThinkingSphinx::RealTime.callback_for(:referral)


	REFERAL_STATUS = ["Joined", "Pending"]
	PAYMENT_STATUS = ["Paid", "Unpaid"]

	before_create :set_defaults

	def set_defaults
		self.referral_status = "Pending"
		self.payment_status = "Unpaid"
	end
end
