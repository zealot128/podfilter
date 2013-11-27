Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, ENV['TWITTER_CONSUMER_KEY'], ENV['TWITTER_CONSUMER_SECRET']
  provider :github,  ENV['GITHUB_CONSUMER_KEY'], ENV['GITHUB_CONSUMER_SECRET'], scope: 'user:email'
  provider :facebook,ENV['FACEBOOK_CONSUMER_KEY'], ENV['FACEBOOK_CONSUMER_SECRET']
  provider :gplus,   ENV['GPLUS_CONSUMER_KEY'], ENV['GPLUS_CONSUMER_SECRET']
end
