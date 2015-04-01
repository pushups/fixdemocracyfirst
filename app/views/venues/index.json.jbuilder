json.array!(@venues) do |venue|
  json.extract! venue, :id, :rwu_id, :name, :street_address1, :street_address2, :unit, :city, :state, :postal_code, :url, :latitude, :longitude
  json.url venue_url(venue, format: :json)
end
