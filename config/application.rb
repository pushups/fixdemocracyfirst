require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# wraps basic auth around the resque_web route (and nowhere else)
class ResqueAuth < Rack::Auth::Basic
  def call(env)
    if Rack::Request.new(env).path =~ /\A\/resque_web\/?/
      super
    else
      @app.call(env)
    end
  end
end

module NhrQuestioner  
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    config.autoload_paths << Rails.root.join('lib')

    # add paths for bower    
    config.assets.paths << Rails.root.join("vendor","assets","bower_components")
    config.assets.paths << Rails.root.join("vendor","assets","bower_components","bootstrap-sass-official","assets","fonts")
    config.assets.precompile << %r(.*.(?:eot|svg|ttf|woff)$)
    # authenticate against these hardcoded values for resque web access
    config.middleware.use ResqueAuth do |username, password|
      username == "questionr" and password == ENV['RESQUE_ADMIN_PASSWORD']
    end
    config.janrain_api_url = URI.parse "https://questionr.rpxnow.com/api/v2/auth_info"
    config.janrain_api_key = ENV['JANRAIN_API_KEY']
    config.janrain_token_url = "#{ENV['URL']}/user/social_auth"

    config.active_job.queue_adapter = :resque
  end
end

#extend the timezone eigenclass so that it makes a *little* more sense
AMERICA_NEW_YORK_TIME_ZONE = ActiveSupport::TimeZone["America/New_York"]
class << AMERICA_NEW_YORK_TIME_ZONE
  def abbr
    self.now.strftime('%Z')
  end

  def desc
    self.to_s
  end
  
  def format_time(t, long = true)
    return '' unless t
    "#{t.in_time_zone(self).strftime('%I:%M %p')} #{long ? self.desc : self.abbr}"
  end
  
  def format_date(t)
    return '' unless t
    "#{t.strftime('%B %-d, %Y')}"
  end
end

#set up connections to external services
REDIS = Redis.new url: ENV['REDISTOGO_URL']
Resque.redis = REDIS

PG_MAX_INT = 2147483647
SUPPORTED_HTML_TAGS = %w(h3 h4 h5 h6 a p em strong br ol ul li)