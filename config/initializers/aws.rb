#TODO export these to ENV variables (which don't seem to be available from initializers, d'oh)
#S3_BUCKET = Aws::S3::Resource.new(region: ENV['AWS_REGION']).bucket(ENV['S3_BUCKET'])
S3_BUCKET = Aws::S3::Resource.new(region: 'us-east-1').bucket(ENV['S3_BUCKET'])