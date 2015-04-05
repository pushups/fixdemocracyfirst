class Candidate < ActiveRecord::Base
  belongs_to :person
  has_many :statements
  has_one :campaign
end
