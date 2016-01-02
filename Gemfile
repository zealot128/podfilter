source 'https://rubygems.org'
ruby '2.2.3'
gem 'rails', '~> 4.2.0'

# TODO https://github.com/rails/rails/pull/19665
# # https://github.com/rack/rack/issues/896
gem 'rack', '1.6.2'

gem 'sass-rails', '~> 5.0.0.beta1'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'ruby-progressbar'
gem 'bootstrap-sass', '>= 3.0.0.0'
gem 'omniauth'
gem 'omniauth-twitter'
gem 'omniauth-github'
gem 'omniauth-facebook'
gem 'omniauth-gplus'
gem 'simple_form', '~> 3.1.0.rc1'
gem 'slim-rails'
gem 'pry-rails'
gem 'pg'
gem 'transaction_retry'
gem 'grape'
gem 'redis'
gem 'logster'
gem 'colorize'

gem 'dotenv-rails'
gem "font-awesome-rails", '~> 4.0'
gem 'pg_search', '~> 0.7.2'
gem 'kaminari', '~> 0.15'
gem 'ancestry'
gem 'whatlanguage'
gem 'sitemap_generator'

gem 'open_uri_redirections'

# https://github.com/mcasimir/kaminari-bootstrap/pull/8/files
gem 'kaminari-bootstrap', github: 'GBH/kaminari-bootstrap', branch: 'bootstrap3'
gem 'faraday'
gem 'cancan'
gem 'fastclick-rails'

# gem 'feedzirra', github: 'zealot128/feedzirra'
# gem 'feedzirra', path: 'gems/feedzirra/'
gem 'feedjira'
gem 'nokogiri'
gem 'acts-as-taggable-on'

gem 'sidekiq', '~> 3.5'
gem 'sinatra', require: false
# gem 'sidekiq-unique-jobs'
gem 'rack-raw-upload'
gem 'jquery.fileupload-rails'
gem 'carrierwave'
gem 'mini_magick'
gem 'validate_url'
gem 'stringex'
gem 'quilt'
gem 'rmagick'
gem 'kramdown'

group :unrequired do
  gem 'whenever'
end

group :production do
  gem 'exception_notification', github: 'smartinez87/exception_notification'
end

group :development do
  gem 'pry-stack_explorer'
  gem 'habtm_generator'
  gem 'thin'
  gem 'binding_of_caller', :platforms=>[:mri_19, :mri_20, :rbx]
  gem 'foreman'
  gem 'haml2slim'
  gem 'html2haml'
  gem 'quiet_assets'
  gem 'rb-inotify', :require=>false
  gem "rack-dev-mark"
end

group :development, :test do
  gem 'fabrication'
  gem 'rspec-rails'#, git: 'https://github.com/rspec/rspec-rails.git'
end
group :test do
  gem 'capybara', '~>2.2.0.rc1'
  # gem 'poltergeist'
  gem 'vcr'
  gem 'webmock'
  gem 'simplecov', require: false
end
# gem "lograge"
gem 'highcharts-rails'
