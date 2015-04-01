json.array!(@statements) do |statement|
  json.extract! statement, :id, :rwu_id, :user_id, :event_day_id, :campaign_id, :candidate_id, :title, :url, :description, :approved
  json.url statement_url(statement, format: :json)
end
