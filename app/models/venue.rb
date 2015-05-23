class Venue < ActiveRecord::Base
  def self._sync_columns; []; end      
  def _sync_columns; Venue._sync_columns; end  
  include DirtyColumns
  has_many :events
  after_save { |v| v.geocode if self.street_address1_changed? or
                                self.city_changed? or
                                self.state_changed? or
                                self.postal_code_changed? }
                                
  def self.default_scope
    order(:name)
  end
                                    
  def Venue.geocode_all(_logger = logger)
    logger = _logger if _logger
    logger.info 'Starting venue geocoding...'
    Venue.where(latitude: nil, longitude: nil)
         .where("postal_code IS NOT NULL OR (street_address1 IS NOT NULL AND city IS NOT NULL AND state IS NOT NULL)")
         .each do |venue|
      venue.geocode(logger)
    end
    logger.info 'Finished venue geocoding'
  end
  
  def geocode(_logger = logger)
    logger = _logger if _logger
    if self.street_address1
      address = [self.street_address1, self.city, self.state, self.postal_code].compact.join(',')
      results = Geocoder.geocode(address: address)
    else
      results = Geocoder.geocode(zip: self.postal_code)
    end
    if results[:error]
      logger.info "Couldn't geocode venue #{self.id}. Error: #{results[:error]}"
      false
    else
      self.update_columns(latitude: results[:lat], longitude: results[:long])
      true
    end
  end
end

