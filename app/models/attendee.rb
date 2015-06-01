class Attendee < ActiveRecord::Base
  include Emailer
  belongs_to :user
  belongs_to :event_day

  accepts_nested_attributes_for :user, allow_destroy: false

  attr_reader :user_name, :event_day_name
  
  after_create :notify_nhr
  
  def notify_nhr
    Emailer.email("ellen@nhrebellion.org", 
                  "Ellen", 
                  "New Event RSVP from Questionr", 
                  "rsvp_details", 
                  attendee: self)
  end
  
  def user_name
    u = self.user
    u ? "#{u.desc}" : ""
  end  
  
  def event_day_name
    ed = self.event_day
    ed ? "#{ed.name}" : ""
  end
end 
