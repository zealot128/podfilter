if !Rails.env.test?
  require 'exception_notification/sidekiq'
  Sidekiq.configure_server do |config|
    config.redis = { url: 'redis://127.0.0.1:6379/0', namespace: "sidekiq_podfilter_#{Rails.env}" }
  end

  Sidekiq.configure_client do |config|
    config.redis = { url: 'redis://127.0.0.1:6379/0', namespace: "sidekiq_podfilter_#{Rails.env}" }
  end
end
