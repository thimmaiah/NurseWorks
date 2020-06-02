class RecurringRequest < ApplicationRecord


	validates_presence_of :user_id, :hospital_id
	
	belongs_to :hospital
	belongs_to :user
	belongs_to :preferred_carer, class_name: "User"
	has_many :staffing_requests

	# Audit of all requests generated from this
	serialize :audit, Hash
	serialize :dates, Array


	before_create :set_defaults
	def set_defaults
		self.audit = {}
		self.speciality = "Generalist" if self.speciality == nil
	end

	after_create :enque_rr_job
	def enque_rr_job
		RecurringRequestJob.perform_later(self.id)
	end

	# This takes the following params
	# time_only - this is the start_date or end_date put into the RecurringRequest, which captures the time
	# wday - the day of the week the request is being genrated for
	# week - The week for which the request is being generated 
	def get_date(time_only, wday, week)
    	d = week.beginning_of_week + time_only.strftime('%H').to_i.hours + time_only.strftime('%M').to_i.minutes + (wday - 1).days
    	d.in_time_zone("London").strftime("%d/%m/%Y %H:%M")
  	end
		

	def create_for_dates
		req_count = 0
		self.dates.each do |d|
			logger.debug "RecurringRequest: Generating requests for #{self.id} #{d}"
			date = Date.parse(d)
			start_date = date + self.start_date.strftime('%H').to_i.hours + self.start_date.strftime('%M').to_i.minutes
	        logger.debug "RecurringRequest: #{date} + #{self.start_date.strftime('%H').to_i} + #{self.start_date.strftime('%M').to_i} #{start_date}"
			
			if(self.start_date < self.end_date)
	        	# End date is the same day
	        	end_date = date + self.end_date.strftime('%H').to_i.hours + self.end_date.strftime('%M').to_i.minutes
	        else
	        	# End date is the next day - so add 1 day
	        	end_date = date + 1.day + self.end_date.strftime('%H').to_i.hours + self.end_date.strftime('%M').to_i.minutes
	        end

			created = self.create_request(start_date, end_date)
			req_count += 1 if created
		end
		self.save
		return req_count
	end

	def create_request(start_date, end_date)

		if self.audit[start_date]
			logger.debug "RecurringRequest: Already generated request #{self.audit[start_date]} for #{start_date} and #{end_date}. Skipping"
			return false
		else
       
	        req = StaffingRequest.new(hospital_id: self.hospital_id, user_id: self.user_id, 
	                                  role: self.role, speciality: self.speciality,
	                                  start_date: start_date, end_date: end_date,
	                                  preferred_carer_id: self.preferred_carer_id,
	                                  recurring_request_id: self.id,
	                                  po_for_invoice: self.po_for_invoice,
	                                  start_code: rand.to_s[2..5], end_code: rand.to_s[2..5])

	        req.save!
	        logger.debug "RecurringRequest: Generated request #{req.to_json} for #{start_date} and #{end_date}"
	        
	        self.audit[req.start_date] = "#{req.id}"
	        return true
	    end
	end

	def preferred_carer
		User.find(preferred_carer_id) if preferred_carer_id
	end


end
