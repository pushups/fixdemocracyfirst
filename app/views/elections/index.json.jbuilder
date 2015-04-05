json.array!(@elections) do |election|
  json.extract! election, :id, :rwu_id, :name, :state, :office_type_id, :special, :election_year
  json.url election_url(election, format: :json)
end
