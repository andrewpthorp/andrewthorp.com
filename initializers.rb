TumblRb.configure do |config|
  config.consumer_oauth_key = ENV["TUMBLR_KEY"]
  config.timeout = config.open_timeout = 3
end
