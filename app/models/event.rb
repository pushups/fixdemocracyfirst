require 'rss'

class Event < ActiveRecord::Base  
  def self._sync_columns; ["title", "description", "official_url"]; end      
  def _sync_columns; Event._sync_columns; end  
  include DirtyColumns
  
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  
  belongs_to :venue
  has_many :event_days, -> { order('date').order('start_time') }
  has_many :attendees, through: :event_days
  has_many :users, through: :attendees
  has_and_belongs_to_many :candidates #TODO add ordering through people
  has_and_belongs_to_many :people, -> { order('last_name').order('nickname').order('first_name').order('middle_name') }
  
  attr_reader :venue_name
    
  scope :joins_event_days, -> {
    joins('inner join event_days on event_days.event_id = events.id')
      .order('event_days.date')
      .order('event_days.start_time') }
  
  scope :upcoming, -> {
    joins_event_days.where('event_days.start_time > now()') }

  scope :past, -> {
    joins_event_days.where('event_days.end_time < now()') }
        
  #configure elastic search
  def as_indexed_json(options = {})
    as_json(only: [:title, :description],
            methods: [:format_candidates, :format_speakers, :format_location])
  end
  
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
  
  def format_start_date
    start_day = self.event_days.first
    (start_day ? (start_day.date ? AMERICA_NEW_YORK_TIME_ZONE.format_date(start_day.date) : '') : '').gsub(' ', '&nbsp;').html_safe
  end
  
  def format_speakers
    self.people.map(&:full_name).join(', ')
  end
  
  def format_people
    (self.candidates.map(&:person_name) + self.people.map(&:full_name)).uniq.join(', ')
  end 
  
  def format_location
    v = self.venue
    if v
      [v.name, v.city, v.state, v.postal_code].delete_if { |d| d.nil? or d.blank? }.join(", ")
    else
      ""
    end
  end
  
  def add_candidate(candidate_id)
    candidate = Candidate.includes(:person).find(candidate_id)
    self.candidates << candidate if candidate
    candidate
  end
  
  def remove_candidate(candidate_id)
    candidate = Candidate.includes(:person).find(candidate_id)
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
    
  def Event.sync_all(_logger = logger)
    logger = _logger if _logger
    logger.info 'Starting event sync...'
    RSS::Parser.parse(open('http://gui.afsc.org/events-new-hampshire/rss').read, false).items.each do |e|
      logger.info "Syncing #{e.link}"
      Event.find_or_initialize_by(rwu_id: Zlib.crc32(e.link.strip) % PG_MAX_INT).sync(e)
    end
    logger.info 'Finished event sync'
  end
  
  def sync(e, _logger = logger)
    logger = _logger if _logger
    updated_fields = []

    #title
    unless self.title_dirty?
      self.title = e.title 
      updated_fields << :title
    end
  
    #official url
    unless self.official_url_dirty?
      self.official_url = e.link.strip 
      updated_fields << :official_url
    end
  
    #description (first sanitize the html embedded therein)
    html_desc = Nokogiri::HTML::DocumentFragment.parse(e.description)
    date_span = html_desc.at_css('span').remove
    html_desc.at_css('br').remove
    unless self.description_dirty?
      self.description = html_desc.to_s
      updated_fields << :description
    end

    self.clean_save!(updated_fields)
  
    event_date = DateTime.parse(date_span.attributes['content'].value)
    if event_date
      updated_event_date_fields = []
      event_day = EventDay.find_or_initialize_by(rwu_id: Zlib.crc32(e.link.strip) % PG_MAX_INT)
      event_day.event_id = self.id
    
      unless event_day.date_dirty?
        event_day.date = event_date
        updated_event_date_fields << :date
      end
    
      unless event_day.start_time_dirty?
        event_day.start_time = event_date
        updated_event_date_fields << :start_time
      end
    
      event_day.clean_save!(updated_event_date_fields)
    end
  rescue Exception => e
    logger.error e
  end
end