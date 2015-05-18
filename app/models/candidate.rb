class Candidate < ActiveRecord::Base
  def self._sync_columns; []; end      
  def _sync_columns; Candidate._sync_columns; end  
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
      .references(:people)
      .order('people.last_name')
      .order('people.nickname')
      .order('people.first_name')
      .order('people.middle_name')
  end

  scope :declared, -> { where("status = 'Declared'") }
  scope :undeclared, -> { where("status <> 'Declared'") } #TODO this is an oversimplification -- candidates have several other statuses
  scope :republicans, -> { where("party = 'Republican'") }
  scope :democrats, -> { where("party = 'Democrat'") }
  scope :others, -> { where("party <> 'Republican' and party <> 'Democrat'") }

  def upcoming_events
    (self.events.upcoming + self.person.events.upcoming).sort_by(&:start_time)
  end

  #configure elastic search
  def as_indexed_json(options = {})
    as_json(only: [:office_id, :posiiton, :district],
            include: [:person],
            methods: [:person_name])
  end

  def person_name
    p = self.person
    p ? p.full_name : ''
  end
  
  def person_image_url
    p = self.person
    p ? "#{p.image_url}" : Person::DEFAULT_IMAGE_URL
  end
  
  def person_title
    p = self.person
    p ? p.title : ''
  end  
  
  def official_url
    c = self.campaign
    c ? c.official_url : ''
  end
end