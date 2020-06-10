class HospitalNurseMappingJob < ApplicationJob
    queue_as :default
  
    def perform()
      Rails.logger.debug "HospitalNurseMappingJob"
      Hospital.verified.each do |h|
        HospitalNurseMapping.populate_nurses(h)
      end  
    end
  end
  