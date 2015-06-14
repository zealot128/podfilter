require File.expand_path('../boot', __FILE__)
require 'rails/all'
Bundler.require(:default, Rails.env)
module Podfilter
  class Application < Rails::Application
    config.middleware.use 'Rack::RawUpload'
    I18n.enforce_available_locales = false
    config.generators do |g|
      g.test_framework :rspec, fixture: true
      g.fixture_replacement :fabrication
      g.view_specs false
      g.helper_specs false
    end
    config.time_zone = 'Berlin'
    config.i18n.default_locale = :de
    # config.lograge.enabled = true
    config.active_record.raise_in_transactional_callbacks = true
    # config.lograge.custom_options = lambda do |event|
    #   (event.payload[:params] || {}).except('utf8', 'action','controller')
    # end
    Logster.store = Logster::RedisStore.new(Redis.new(db: ['development', 'test', 'production'].index(Rails.env)))
    Logster.store.ignore = [/"\/logs/]
  end
end
