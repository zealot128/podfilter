# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require 'simplecov'
SimpleCov.start 'rails'
require File.expand_path("../../config/environment", __FILE__)

require 'sidekiq/testing'
Sidekiq::Testing.fake!
Sidekiq::Logging.logger = nil

require 'rspec/rails'
# require 'rspec/autorun'

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"
  # config.color_enabled = true
  config.tty = true
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock # or :fakeweb
  c.configure_rspec_metadata!
end

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.before(:each) do |example|
    # Clears out the jobs for tests using the fake testing
    Sidekiq::Worker.clear_all

    if example.metadata[:sidekiq] == :fake
      Sidekiq::Testing.fake!
    elsif example.metadata[:sidekiq] == :inline
      Sidekiq::Testing.inline!
    elsif example.metadata[:type] == :acceptance
      Sidekiq::Testing.inline!
    else
      Sidekiq::Testing.fake!
    end
  end
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
end
