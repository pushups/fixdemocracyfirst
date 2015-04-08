class Campaign < ActiveRecord::Base
  include DirtyColumns
  has_many :statements
  belongs_to :election
  belongs_to :candidate
end
