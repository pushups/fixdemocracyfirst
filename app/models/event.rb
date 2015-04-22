class Event < ActiveRecord::Base
  include DirtyColumns
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  
  belongs_to :venue
  has_many :event_days
  has_many :attendees
  has_many :users, through: :attendees
  has_and_belongs_to_many :candidates
  has_and_belongs_to_many :people
  
  attr_reader :venue_name
  
  #roll up the statements from all the event days
  def statements
    Statement.approved
      .joins('inner join event_days on statements.event_day_id = event_days.id')
      .joins('inner join events on event_days.event_id = events.id')
      .where(['events.id = ?', self.id])
  end
  
  def start_time 
    start_day = self.event_days.first
    start_day ? start_day.start_time : nil
  end
  
  def format_candidates
    self.candidates.map(&:person_name).join(', ')
  end

  def format_speakers
    self.people.map(&:full_name).join(', ')
  end
  
  def format_location
    v = self.venue
    if v
      [v.name, v.city, v.state, v.postal_code].delete_if { |d| d.nil? }.join(", ")
    else
      ""
    end
  end

  def venue_name
    v = self.venue
    v ? v.name : '-- No Venue --'
  end
  
  def add_candidate(candidate_id)
    candidate = Candidate.find(candidate_id)
    self.candidates << candidate if candidate
    candidate
  end
  
  def remove_candidate(candidate_id)
    candidate = Candidate.find(candidate_id)
    self.candidates.delete(candidate) if candidate
    candidate
  end

  def add_person(person_id)
    person = Person.find(person_id)
    self.people << person if person
    person
  end
  
  def remove_person(person_id)
    person = Person.find(person_id)
    self.people.delete(person) if person
    person
  end
end