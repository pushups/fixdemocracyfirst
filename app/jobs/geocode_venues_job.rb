class GeocodeVenuesJob < ActiveJob::Base
  queue_as :default

  def perform
    Venue.where(latitude: nil, longitude: nil)
         .where("postal_code IS NOT NULL OR (street_address1 IS NOT NULL AND city IS NOT NULL AND state IS NOT NULL)")
         .each do |venue|
      if venue.street_address1
        address = [venue.street_address1, venue.city, venue.state, venue.postal_code]
          .compact.join(',')
        results = Geocoder.geocode(address: address)
      else
        results = Geocoder.geocode(zip: venue.postal_code)
      end
      if results[:error]
        logger.info "Couldn't geocode venue #{venue.id}. Error: #{results[:error]}"
      else
        venue.update(latitude: results[:lat], longitude: results[:long]) 
      end
    end
  end
end