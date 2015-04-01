json.array!(@candidates) do |candidate|
  json.extract! candidate, :id, :rwu_id, :person_id, :office_id, :position, :district
  json.url candidate_url(candidate, format: :json)
end
