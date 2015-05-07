class GeocodeVenuesJob < ActiveJob::Base
  queue_as :default

  def perform
    Venue.where(latitude: nil, longitude: nil).each do |venue|
      results = nil
      if venue.street_address1 && venue.city && venue.state
        address = [venue.street_address1, venue.city, venue.state].join(',')
        results = Geocoder.geocode(address: address)
      end
      if !results && venue.postal_code
        results = Geocoder.geocode(zip: venue.postal_code)
      end
      venue.update(latitude: results[:lat], longitude: results[:long]) if results
    end
  end
end