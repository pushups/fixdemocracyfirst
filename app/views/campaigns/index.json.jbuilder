json.array!(@campaigns) do |campaign|
  json.extract! campaign, :id, :rwu_id, :candidate_id, :election_id
  json.url campaign_url(campaign, format: :json)
end
