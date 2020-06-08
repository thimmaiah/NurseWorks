class HospitalCarerMappingJob < ApplicationJob
    queue_as :default
  
    def perform()
      Rails.logger.debug "HospitalCarerMappingJob"
      Hospital.verified.each do |h|
        HospitalCarerMapping.populate_carers(h)
      end  
    end
  end
  