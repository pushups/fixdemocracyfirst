class Campaign < ActiveRecord::Base
  include DirtyColumns
  has_many :statements
  belongs_to :election
  belongs_to :candidate
  
  attr_reader :candidate_name
  attr_reader :election_name

  def candidate_name
    c = self.candidate
    c ? c.person_name : '-- Candidate Not Set --'
  end

  def election_name
    e = self.election
    e ? e.name : '-- Election Not Set --'
  end
end
