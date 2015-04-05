class User < ActiveRecord::Base
  has_many :statements
  has_many :attendees
  has_many :events, through: :attendees
end
