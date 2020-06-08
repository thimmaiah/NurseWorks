class GeocodeJob < ApplicationJob
  queue_as :default

  def perform(entity)
    Rails.logger.debug "GeocodeJob: #{entity.addr}"
    coordinates = entity.geocode
    Rails.logger.debug "GeocodeJob: #{entity.lat}, #{entity.lng}"
    entity.save!
  end
end
