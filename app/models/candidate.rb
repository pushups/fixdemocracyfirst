class Candidate < ActiveRecord::Base
  include DirtyColumns
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to :person
  has_many :statements
  has_one :campaign
  has_and_belongs_to_many :events

  before_save { |c| c.person_id = nil if c.person_id < 1 }

  attr_reader :person_name

  def self.default_scope
    includes(:person)
      .order('people.last_name asc')
      .order('people.nickname asc')
      .order('people.first_name asc')
      .order('people.middle_name asc')
  end

  #configure elastic search
  def as_indexed_json(options = {})
    as_json(only: [:office_id, :posiiton, :district],
            include: [:person],
            methods: [:person_name])
  end

  def person_name
    p = self.person
    p ? "#{!p.nickname.blank? ? p.nickname : p.first_name} #{p.last_name}" : ''
  end
  
  def person_image_url
    p = self.person
    p ? "#{p.image_url}" : Person::DEFAULT_IMAGE_URL
  end
  
  def person_title
    p = self.person
    p ? p.title : ''
  end   
end