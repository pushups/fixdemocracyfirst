class Event < ActiveRecord::Base
  include DirtyColumns
  
  belongs_to :venue
  has_many :event_days
  has_many :attendees
  has_many :users, through: :attendees
  
  attr_reader :venue_name
  
  def venue_name
    v = self.venue
    v ? v.name : '-- No Venue --'
  end
end
