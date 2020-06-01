class GeocodeJob < ApplicationJob
  queue_as :default

  def perform(entity)
    coordinates = Geocoder.coordinates(entity.postcode + " UK")
    entity.lat = coordinates[0]
    entity.lng = coordinates[1]
    entity.reverse_geocode
    entity.save!
  end
end
