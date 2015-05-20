class Campaign < ActiveRecord::Base
  def self._sync_columns; []; end      
  def _sync_columns; Campaign._sync_columns; end  
  include DirtyColumns

  has_many :statements
  belongs_to :election
  belongs_to :candidate, lambda { select('candidates.*').select('people.*').joins(:person).order('people.last_name').order('people.first_name').order('people.middle_name') }

  before_save { |c| c.election_id = nil if c.election_id < 1 }
  
  attr_reader :candidate_name, :election_name

  def candidate_name
    c = self.candidate
    c ? c.person_name : ''
  end

  def election_name
    e = self.election
    e ? e.name : ''
  end
  
  def name
    "#{self.candidate_name}: #{self.election_name}"
  end
end
