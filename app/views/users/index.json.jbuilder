json.array!(@users) do |user|
  json.extract! user, :id, :first_name, :last_name, :email, :mobile_phone, :location, :fb_uid, :fb_token, :admin, :postal_code
  json.url user_url(user, format: :json)
end
