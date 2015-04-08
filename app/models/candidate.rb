class Candidate < ActiveRecord::Base
  include DirtyColumns
  belongs_to :person
  has_many :statements
  has_one :campaign
end
