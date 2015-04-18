ThinkingSphinx::Index.define :person, :with => :active_record do
=begin
  indexes first_name, :sortable => true
  indexes middle_name, :sortable => false
  indexes last_name, :sortable => true

  indexes author.name, :as => :author, :sortable => true

  t.string :first_name
  t.string :nickname
  t.string :middle_name
  t.string :last_name
  t.string :suffix
  t.timestamps null: false
  t.index :rwu_id

  has author_id, created_at, updated_at
=end
end