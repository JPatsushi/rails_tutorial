if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      # Amazon S3用の設定
      :provider              => 'AWS',
      :region                => ENV['ap-northeast-1'],     # 例: 'ap-northeast-1'
      :aws_access_key_id     => ENV['AKIAI4PITF3R24JM22IA'],
      :aws_secret_access_key => ENV['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']
    }
    config.fog_directory     =  ENV['test-new-container']
  end
end