json.array!(@attendees) do |attendee|
  json.extract! attendee, :id, :user_id, :event_day_id, :notes
  json.url attendee_url(attendee, format: :json)
end
