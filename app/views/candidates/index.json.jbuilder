json.array!(@candidates) do |candidate|
  json.extract! candidate, :id, :first, :last, :party, :district, :state
  json.url candidate_url(candidate, format: :json)
end
