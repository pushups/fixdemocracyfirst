class EventDay < ActiveRecord::Base
  include DirtyColumns

  belongs_to :event
  has_many :statements

  validate :end_time_must_come_after_start_time

  before_save { |e| e.event_id = nil if e.event_id < 1 }

  attr_reader :event_name

  def event_name
    e = self.event
    e ? "#{e.title}" : "-- No Event --"
  end
   
  private
  
  def end_time_must_come_after_start_time
    if end_time.present? and end_time.present? and start_time > end_time
      errors.add(:end_time, "must come after start time")
    end
  end
end