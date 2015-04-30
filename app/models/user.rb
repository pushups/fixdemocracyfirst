class User < ActiveRecord::Base
  include DirtyColumns

  has_many :statements
  has_many :attendees
  has_many :event_days, through: :attendees
  
  attr_reader :desc
  
  def User.social_refresh(profile)        
    user = User.where(:fb_uid => profile[:identifier]).first_or_initialize
    user.name ||= profile[:preferredUsername]
    user.first_name ||= profile[:name][:givenName]
    user.last_name ||= profile[:name][:familyName]
    user.email ||= profile[:verifiedEmail] || profile[:email]
    user.url ||= profile[:url]
    user.photo ||= profile[:photo]
    user.utc_offset ||= profile[:utcOffset]
    user.gender ||= profile[:gender]
    user.provider ||= profile[:providerName]
    user.save!
    user
  end
  
  def desc
    "ID = #{id} #{first_name} #{last_name} #{email} #{location} #{fb_uid} #{postal_code}".strip
  end
  
  def attending?(event_day)
    raise "expects a non-nil event_day" unless event_day
    self.event_days.include?(event_day)
  end  
end
