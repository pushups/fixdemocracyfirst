class Campaign < ActiveRecord::Base
  has_many :statements
  belongs_to :election
  belongs_to :candidate
end
