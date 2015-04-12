class Candidate < ActiveRecord::Base
  include DirtyColumns

  belongs_to :person
  has_many :statements
  has_one :campaign

  before_save { |c| c.person_id = nil if c.person_id < 1 }

  attr_reader :person_name

  def person_name
    p = self.person
    p ? "#{p.first_name} #{p.last_name}" : "-- No Name --"
  end
end
