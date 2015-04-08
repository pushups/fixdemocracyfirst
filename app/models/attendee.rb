class Attendee < ActiveRecord::Base
  include DirtyColumns
  belongs_to :user
  belongs_to :event
end 
