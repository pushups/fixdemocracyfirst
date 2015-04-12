class Campaign < ActiveRecord::Base
  include DirtyColumns

  has_many :statements
  belongs_to :election
  belongs_to :candidate

  before_save { |c| c.election_id = nil if c.election_id < 1 }
  
  attr_reader :candidate_name
  attr_reader :election_name

  def candidate_name
    c = self.candidate
    c ? c.person_name : '-- No Candidate --'
  end

  def election_name
    e = self.election
    e ? e.name : '-- No Election --'
  end
end
