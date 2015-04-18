Elasticsearch::Model.client = Elasticsearch::Client.new host: ENV['SEARCHBOX_URL'], log: true

#add a reindex method, specific the data we want to make searchable
module Elasticsearch
  module Model
    def self.reindex
      [Candidate, Event].each { |model| model.import }
      puts "All done"
    end
  end
end