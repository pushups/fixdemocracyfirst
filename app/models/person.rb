class Person < ActiveRecord::Base
  include DirtyColumns
  has_many :candidates #candidacies 
end
