class StatGenerator

	def verified
		User.temps.count
		User.admins.count
	end

	def operations_data
		# i. Number of registered and verified Carers / Nurses / Care homes registered (Cumulative and Weekly numbers)
        # ii. Number of carer logins in the last 30 days
        # iii. Number of carer with 0, 1-5, 5-10 & 10+ shifts in the last one month
	end
end