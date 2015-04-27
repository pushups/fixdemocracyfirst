json.array!(@people) do |person|
  json.extract! person, :id, :rwu_id, :first_name, :nickname, :middle_name, :last_name, :suffix, :title
  json.url person_url(person, format: :json)
end
