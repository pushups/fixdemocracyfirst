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
  include DirtyColumns

  belongs_to :user
  belongs_to :event_day
  belongs_to :campaign
  belongs_to :candidate
  scope :approved, -> { where(approved: true).where('youtube_url is not null').order('updated_at desc') }
  
  accepts_nested_attributes_for :user, allow_destroy: false

  attr_reader :user_name, :event_name, :campaign_name, :candidate_name

  def user_name
    u = self.user
    u ? u.desc : '-- No User --'
  end
  
  def event_name
    ed = self.event_day
    return '-- No Event --' unless ed
    e = ed.event
    e ? e.title : '-- No Event --'
  end
  
  def campaign_name
    c = self.campaign
    c ? c.name : '-- No Campaign --'
  end
  
  def candidate_name
    c = self.candidate
    c ? c.person_name : '-- No Candidate --'
  end 
  
  def youtube_embed_url
    self.youtube_url ? self.youtube_url.gsub('watch?v=', 'embed/') : ''
  end
  
  #TODO (wip) clean this up and make it work, prolly wanna async it with resque, too
  def upload_to_youtube(video) 
    logger.debug ap(video)
    #authenticate as youtube channel user and get an access_token
    access_token = JSON.parse(Net::HTTP.post_form(URI.parse(YT_TOKEN_URL), 
    { client_id: YT_CLIENT_ID,
      client_secret: YT_CLIENT_SECRET,
      refresh_token: YT_REFRESH_TOKEN,
      grant_type: 'refresh_token' }).body)['access_token']

    logger.debug "ACCESS TOKEN = #{access_token}"

    #upload the video to a local cache, one folder per day
    cache_dir = Rails.root.join('upload_cache', DateTime.now.strftime("%Y-%m-%d"))
    Dir.mkdir(cache_dir) unless File.exists?(cache_dir)
    File.open(cache_dir.join(video.original_filename), 'wb') do |file|
      #write file to cache
      file.write(video.read)
    
      #prepare to post to youtube
      post_body = []
      post_body << '--#{BOUNDARY}rn'
      post_body << "Content-Disposition: form-data; name='datafile'; filename='#{File.basename(file)}'rn"
      post_body << 'Content-Type: video/*rn'
      post_body << 'rn'
      post_body << File.read(file)
      post_body << 'rn--#{BOUNDARY}--rn'
      uri = URI(YT_VIDEOS_URL)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request = Net::HTTP::Post.new(uri.request_uri)
      request.body = post_body.join
      request['Content-Type'] = "multipart/form-data, boundary=#{BOUNDARY}"
      request['Authorization'] = "Bearer #{access_token}"
      request['content-type'] = 'application/json; charset=utf-8'
      request['X-upload-content-length'] = File.size(file)
      request['X-upload-content_type'] = 'application/octet-stream'
      #request['X-upload-content-type'] = FileMagic.new(FileMagic::MAGIC_MIME).file(file)    
      request.set_form_data({
        'status': {
          'privacyStatus': 'private',
          'license': 'creativeCommon',
          'embeddable': 'true'
        },
        'categoryId': '29', #Activism
        'recordingDate': DateTime.now.iso8601,
        'part': 'status',
        'uploadType': 'resumable',
        'alt': 'json'
=begin
        'title': '',
        'description': '',
        'locationDescription', ''
        data['location']: {
          'latitude': '',
          'longitude': ''
        }
=end
      })
      logger.debug ap(request)
      #post video to youtube
      response = http.request(request)
      logger.debug ap(response.body)
    end
  end
end