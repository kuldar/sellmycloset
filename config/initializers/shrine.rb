require 'shrine/storage/s3'

# S3 options
s3_options = {
  access_key_id: ENV['S3_ACCESS_KEY'],
  secret_access_key: ENV['S3_SECRET_KEY'],
  region: ENV['S3_REGION'],
  bucket: ENV['S3_BUCKET']
}

# Shrine storages
Shrine.storages = {
  cache: Shrine::Storage::S3.new(prefix: 'cache', upload_options: {acl: 'public-read'}, **s3_options),
  store: Shrine::Storage::S3.new(prefix: 'store', upload_options: {acl: 'public-read'}, **s3_options)
}

# Shrine plugins
Shrine.plugin :activerecord
Shrine.plugin :direct_upload
Shrine.plugin :restore_cached_data
Shrine.plugin :remote_url, max_size: 20*1024*1024