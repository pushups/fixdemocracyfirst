class User < ActiveRecord::Base
  include DirtyColumns
  has_many :statements
  has_many :attendees
  has_many :events, through: :attendees
  
  attr_reader :desc
  
  def desc
    "ID = #{id} #{first_name} #{last_name} #{email} #{location} #{fb_uid} #{postal_code}".strip
  end
end
