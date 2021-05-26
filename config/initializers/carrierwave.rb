CarrierWave.configure do |config|
  if Rails.env.production? || Rails.env.development?
    config.fog_provider = 'fog/aws'
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: 'AKIAYSXC76VGMPDEKV53',
      aws_secret_access_key: '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',
      region: 'ap-northeast-1'
    }
    config.fog_public     = true
    config.fog_attributes = { 'Cache-Control' => "max-age=#{365.day.to_i}" }
    config.cache_storage = :fog
  end

  case Rails.env
  when 'production'
    config.asset_host = 'https://workeasyhq.s3-ap-northeast-1.amazonaws.com',
    config.fog_directory  = 'workeasyhq'
  when 'development'
    config.asset_host = 'https://workeasy-dev.s3-ap-northeast-1.amazonaws.com',
    config.fog_directory  = 'workeasy-dev'
  end
end

CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:]\.\-\+]/
