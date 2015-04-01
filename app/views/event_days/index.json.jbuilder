json.array!(@event_days) do |event_day|
  json.extract! event_day, :id, :rwu_id, :event_id, :date, :start_time, :end_time
  json.url event_day_url(event_day, format: :json)
end
