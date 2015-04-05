class Event < ActiveRecord::Base
  belongs_to :venue
  has_many :event_days
  has_many :attendees
  has_many :users, through: :attendees
end
