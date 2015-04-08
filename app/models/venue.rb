class Venue < ActiveRecord::Base
  include DirtyColumns
  has_many :events  
end


