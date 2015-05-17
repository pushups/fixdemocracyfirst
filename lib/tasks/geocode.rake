namespace :geocode do
  task :venues => :environment do
    Venue.geocode_all Logger.new(STDOUT)
  end
end