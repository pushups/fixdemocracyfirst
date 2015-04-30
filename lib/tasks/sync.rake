namespace :sync do
  task :events => :environment do
   Event.sync Logger.new(STDOUT)
  end
end