class Attendee < ActiveRecord::Base
  include DirtyColumns

  belongs_to :user
  belongs_to :event_day

  attr_reader :user_name, :event_day_name
  
  def user_name
    u = self.user
    u ? "#{u.desc}" : "-- No User --"
  end  
  
  def event_day_name
    ed = self.event_day
    ed ? "#{ed.name}" : "-- No Event Day --"
  end
end 
