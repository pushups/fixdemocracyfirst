namespace :sync do
  task :events => :environment do
   Event.sync_all Logger.new(STDOUT)
  end
end