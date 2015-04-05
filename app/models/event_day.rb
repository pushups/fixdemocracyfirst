class EventDay < ActiveRecord::Base
  belongs_to :event
  has_many :statements
end
