json.array!(@events) do |event|
  json.extract! event, :id, :rwu_id, :title, :description, :venue_id, :public, :image_url
  json.url event_url(event, format: :json)
end
