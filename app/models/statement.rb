require 'net/http'
require 'uri'
require 'json'
require 'awesome_print'

YT_CLIENT_ID = ENV['YT_CLIENT_ID']
YT_CLIENT_SECRET = ENV['YT_CLIENT_SECRET']
YT_REFRESH_TOKEN = ENV['YT_REFRESH_TOKEN']
YT_TOKEN_URL = 'https://accounts.google.com/o/oauth2/token'
YT_VIDEOS_URL = 'https://www.googleapis.com/upload/youtube/v3/videos'
BOUNDARY = '¸.·´¯`·.´¯`·.¸¸.·´¯`·.¸><(((º>'

class Statement < ActiveRecord::Base
  def self._sync_columns; []; end      
  def _sync_columns; Statement._sync_columns; end  
  include DirtyColumns

  belongs_to :user
  belongs_to :event_day
  belongs_to :campaign
  belongs_to :candidate

  default_scope { includes(:event_day).order("event_days.date desc").order("statements.created_at desc") } 
  scope :approved, -> { includes(:event_day)
                          .where(approved: true)
                          .where('youtube_url is not null')
                          .order('event_days.date desc') }

  accepts_nested_attributes_for :user, allow_destroy: false

  attr_reader :user_name, :event_name, :campaign_name, :candidate_name

  def user_name
    u = self.user
    u ? u.desc : ''
  end
  
  def event_name
    ed = self.event_day
    return '' unless ed
    e = ed.event
    e ? e.title : ''
  end
  
  def campaign_name
    c = self.campaign
    c ? c.name : ''
  end
  
  def candidate_name
    c = self.candidate
    c ? c.person_name : ''
  end 
  
  def youtube_embed_url
    self.youtube_url ? self.youtube_url.gsub('watch?v=', 'embed/') : ''
  end
  
  def date
    self.event_day ? self.event_day.date : self.created_at 
  end
end