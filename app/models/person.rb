class Person < ActiveRecord::Base
  include DirtyColumns

  has_many :candidates #candidacies 
  has_and_belongs_to_many :events #speakers

  attr_reader :full_name

  def full_name(include_middle = false)
    "#{self.first_name}#{include_middle ? ' ' + self.middle_name : ''} #{self.last_name}"
  end
end
