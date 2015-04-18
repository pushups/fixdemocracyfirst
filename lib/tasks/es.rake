namespace :es do
  task :reindex => :environment do
   Elasticsearch::Model.reindex
  end
end