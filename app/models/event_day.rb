class EventDay < ActiveRecord::Base
  include DirtyColumns
  belongs_to :event
  has_many :statements
end
