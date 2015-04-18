ThinkingSphinx::Index.define :candidate, :with => :active_record do
  indexes person.first_name, :as => :first_name
  indexes person.middle_name, :as => :middle_name
  indexes person.last_name, :as => :last_name

  has office_id, position, district, created_at, updated_at
end