class Attendee < ActiveRecord::Base
  belongs_to :user
  belongs_to :event_day

  accepts_nested_attributes_for :user, allow_destroy: false

  attr_reader :user_name, :event_day_name
  
  def user_name
    u = self.user
    u ? "#{u.desc}" : ""
  end  
  
  def event_day_name
    ed = self.event_day
    ed ? "#{ed.name}" : ""
  end
end 
