require 'net/http'
require 'uri'
require 'json'
#require 'filemagic'

class Video < ActiveRecord::Base
  YT_CLIENT_ID = ENV['YT_CLIENT_ID']
  YT_CLIENT_SECRET = ENV['YT_CLIENT_SECRET']
  YT_REFRESH_TOKEN = ENV['YT_REFRESH_TOKEN']
  YT_TOKEN_URL = 'https://accounts.google.com/o/oauth2/token'
  YT_VIDEOS_URL = 'https://www.googleapis.com/upload/youtube/v3/videos'
  BOUNDARY = '¸.·´¯`·.´¯`·.¸¸.·´¯`·.¸><(((º>'
    
  def upload(video)
    #authenticate as youtube channel user and get an access_token
    access_token = JSON.parse(Net::HTTP.post_form(URI.parse(YT_TOKEN_URL), 
    { client_id: YT_CLIENT_ID,
      client_secret: YT_CLIENT_SECRET,
      refresh_token: YT_REFRESH_TOKEN,
      grant_type: 'refresh_token' }).body)['access_token']

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
      request['Authorization'] = "Bearer %s #{access_token}"
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
      #post video to youtube
      http.request(request)
    end
  end
end