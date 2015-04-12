class Candidate < ActiveRecord::Base
  include DirtyColumns

  belongs_to :person
  has_many :statements
  has_one :campaign

  before_save { |c| c.campaign_id = nil if c.campaign_id < 1 }

  attr_reader :person_name

  def person_name
    p = self.person
    p ? "#{p.first_name} #{p.last_name}" : "-- Name Not Set --"
  end
end
