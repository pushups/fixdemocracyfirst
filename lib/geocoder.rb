class Geocoder
  URL = 'rpc.geocoder.us/service/json'

  def self.geocode(params)
    parse_response(get_json(build_url(params)))
  end

  private

  def self.parse_response(response)
    # TODO: handle multiple responses?
    response.first.symbolize_keys
  end

  def self.get_json(url)
    response = Faraday.get(url)
    JSON.parse(response.body)
  end

  def self.build_url(params = {})
    ['http://', URL, '?', params.to_query].join
  end
end
