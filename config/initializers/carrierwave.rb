CarrierWave.configure do |config|
  config.fog_credentials = {
    provider:              'AWS',
    aws_access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
    aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
    region:                'sa-east-1'
  }
  config.fog_directory  = ENV['FOG_DIRECTORY']
  config.asset_host = "//#{ENV['CLOUDFRONT_DOMAIN']}"
  config.fog_attributes = { 'Cache-Control'=>'max-age=31536000' }
end
