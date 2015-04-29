class EventDay < ActiveRecord::Base
  include DirtyColumns

  belongs_to :event
  has_many :statements
  has_many :attendees
  has_many :users, through: :attendees

  validate :end_time_must_come_after_start_time

  before_save { |e| e.event_id = nil if e.event_id < 1 }

  attr_reader :event_name, :name

  def self.default_scope
    order('date desc').order('start_time desc')
  end

  def event_name
    e = self.event
    e ? "#{e.title}" : ""
  end
  
  def name
    if self.date
      "#{event_name} (#{self.date.strftime('%m/%d/%Y')})"
    else
      "#{event_name} (ID = #{self.id})"
    end      
  end
   
  private
  
  def end_time_must_come_after_start_time
    if end_time.present? and end_time.present? and !start_time.nil? and !end_time.nil? and start_time > end_time
      errors.add(:end_time, "must come after start time")
    end
  end
end