class Candidate < ActiveRecord::Base
  include DirtyColumns
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to :person
  has_many :statements
  has_one :campaign
  has_and_belongs_to_many :events

  before_save { |c| c.person_id = nil if c.person_id < 1 }

  attr_reader :person_name

  def person_name
    p = self.person
    p ? "#{p.first_name} #{p.last_name}" : "-- No Name --"
  end
  
  def person_image_url
    p = self.person
    p ? "#{p.image_url}" : Person::DEFAULT_IMAGE_URL
  end   
end
