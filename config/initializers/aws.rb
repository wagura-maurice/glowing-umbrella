require 'aws-sdk'

Aws.config.update({
  region: ENV['AWS_REGION'],
  credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'])
})

if ENV['S3_BUCKET'].present?
  S3_BUCKET = Aws::S3::Resource.new.bucket(ENV['S3_BUCKET'])
end