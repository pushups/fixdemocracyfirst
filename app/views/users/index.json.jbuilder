json.array!(@users) do |user|
  json.extract! user, :id, :fullname, :email, :location, :fb_uid, :fb_token, :admin
  json.url user_url(user, format: :json)
end
