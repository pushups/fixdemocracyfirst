class Election < ActiveRecord::Base
  has_one :campaigns
end
