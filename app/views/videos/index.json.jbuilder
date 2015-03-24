json.array!(@videos) do |video|
  json.extract! video, :id, :user_id, :event_id, :candidate_id, :title, :url, :question_text, :stars
  json.url video_url(video, format: :json)
end
