class Election < ActiveRecord::Base
  include DirtyColumns
  has_one :campaigns
end
