class Payment < ApplicationRecord

	acts_as_paranoid
	after_save ThinkingSphinx::RealTime.callback_for(:payment)
	
	belongs_to :user
	belongs_to :care_home
	belongs_to :shift
	belongs_to :staffing_request
	belongs_to :paid_by, class_name: "User", foreign_key: :paid_by_id	

	after_create :update_payment_status
	before_destroy :revert_payment_status

	def update_payment_status
		if(self.shift)
			self.shift.payment_status = "Pending"
			self.shift.care_home_payment_status = "Pending"
			self.shift.save
		end
	end

	def revert_payment_status
		if(self.shift)
			self.shift.payment_status = nil
			self.shift.care_home_payment_status = nil
			self.shift.save
		end
	end

	INCENTIVE = {
					"Care Giver" => {"24-48" => 0.25, "48-72" => 0.5, ">72" => 1.0},
					"Nurse" 	 => {"24-48" => 1.5,  "48-72" => 2.5, ">72" => 5.0}
				}

	def self.generate_incentive(user, date)
		hours_worked = (user.mins_worked_in_month(date) / 60).round(0)
		logger.debug "Payment.generate_incentive: User #{user.id} worked #{hours_worked} hours for month #{date.beginning_of_month}"
		key = nil
		if(hours_worked >= 24 && hours_worked < 48)
			key = "24-48"
		elsif (hours_worked >= 48 && hours_worked < 72)
			key = "48-72"
		elsif (hours_worked >= 72)		
			key = ">72"
		end
		
	end
end
