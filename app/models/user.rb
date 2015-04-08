class User < ActiveRecord::Base
  include DirtyColumns
  has_many :statements
  has_many :attendees
  has_many :events, through: :attendees
end
