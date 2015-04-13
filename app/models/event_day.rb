class EventDay < ActiveRecord::Base
  include DirtyColumns
  belongs_to :event
  has_many :statements

  before_save { |e| e.event_id = nil if e.event_id < 1 }

  attr_reader :event_name

  def event_name
    e = self.event
    e ? "#{e.title}" : "-- No Event --"
  end
end