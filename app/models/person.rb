class Person < ActiveRecord::Base
  include DirtyColumns
  
  DEFAULT_IMAGE_URL = 'default_person.png'

  has_many :candidates #candidacies 
  has_and_belongs_to_many :events #speakers

  attr_reader :full_name

  def full_name(include_middle = false)
    "#{self.first_name}#{include_middle ? ' ' + self.middle_name : ''} #{self.last_name}"
  end
  
  def image_url
    img = read_attribute(:image_url)
    img ? img : DEFAULT_IMAGE_URL
  end
end
