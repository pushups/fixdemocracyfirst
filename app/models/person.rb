class Person < ActiveRecord::Base
  def self._sync_columns; []; end      
  def _sync_columns; Person._sync_columns; end  
  include DirtyColumns
  
  DEFAULT_IMAGE_URL = 'default_person.png'

  has_many :candidates #candidacies 
  has_and_belongs_to_many :events #speakers
  
  attr_reader :full_name
  
  def self.default_scope
    order('last_name asc')
      .order('nickname asc')
      .order('first_name asc')
      .order('middle_name asc')
  end
  
  def full_name(include_middle = false)
    "#{!self.nickname.blank? ? self.nickname : self.first_name}#{include_middle ? ' ' + self.middle_name : ''} #{self.last_name}"
  end
  
  def image_url
    img = read_attribute(:image_url)
    img ? img : DEFAULT_IMAGE_URL
  end
end
