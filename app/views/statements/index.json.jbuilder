json.array!(@statements) do |statement|
  json.extract! statement, :id, :rwu_id, :user_id, :event_day_id, :campaign_id, :candidate_id, :title, :url, :description, :approved, :ugc_candidate_name, :ugc_date, :ugc_event_title, :ugc_event_location, :ugc_notes
  json.url statement_url(statement, format: :json)
end
