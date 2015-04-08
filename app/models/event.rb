class Event < ActiveRecord::Base
  include DirtyColumns
  belongs_to :venue
  has_many :event_days
  has_many :attendees
  has_many :users, through: :attendees
end
