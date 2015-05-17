module Geocoder
  URL = 'rpc.geocoder.us/service/json'

  def self.geocode(params)
    parse_response(get_json(build_url(params)))
  end

  private

  def self.parse_response(response)
    response.try(:first).try(:symbolize_keys) || { error: "response not in expected format" }
  end

  def self.get_json(url)
    response = Faraday.get(url)
    if response.status == 200
      JSON.parse(response.body)
    else
      [{ error: "address not recognized" }]
    end
  rescue JSON::ParserError => e
    [{ error: "bad JSON: #{e.message}" }]
  end

  def self.build_url(params = {})
    ['http://', URL, '?', params.to_query].join
  end
end
