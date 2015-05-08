class GeocodeVenuesJob < ActiveJob::Base
  queue_as :default

  def perform
    Venue.where(latitude: nil, longitude: nil).each do |venue|
      if venue.street_address1 && ((venue.city && venue.state) || venue.postal_code)
        address = [venue.street_address1, venue.city, venue.state, venue.postal_code]
          .compact.join(',')
        results = Geocoder.geocode(address: address)
      elsif venue.postal_code
        results = Geocoder.geocode(zip: venue.postal_code)
      else
        next
      end
      if results[:error]
        logger.info "Couldn't geocode venue #{venue.id}. Error: #{results[:error]}"
      else
        venue.update(latitude: results[:lat], longitude: results[:long]) 
      end
    end
  end
end