source 'https://rubygems.org'
ruby '2.1.1'
gem 'rails', '4.1.0.rc1'
gem 'sass-rails', '~> 4.0'
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
gem 'simple_form'
gem 'slim-rails'
gem 'pry-rails'
gem 'pg'
gem 'dotenv-rails'
gem "font-awesome-rails", '~> 4.0'
gem 'pg_search', '~> 0.7.2'
gem 'kaminari', '~> 0.15'
gem 'ancestry'
gem 'whatlanguage'
gem 'sitemap_generator'

# https://github.com/mcasimir/kaminari-bootstrap/pull/8/files
gem 'kaminari-bootstrap', github: 'GBH/kaminari-bootstrap', branch: 'bootstrap3'
gem 'faraday'
gem 'cancan'
gem 'fastclick-rails'

# gem 'feedzirra', github: 'zealot128/feedzirra'
# gem 'feedzirra', path: 'gems/feedzirra/'
gem 'feedzirra'
gem 'nokogiri'
gem 'acts-as-taggable-on'

gem 'sidekiq', github: 'mperham/sidekiq' # Capistrano 3 problems https://github.com/mperham/sidekiq/blob/master/lib/sidekiq/tasks/sidekiq.rake
gem 'sinatra', require: false
gem 'sidekiq-unique-jobs'
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
  gem 'capistrano', '~> 3.0.1'
  gem 'capistrano-rvm', github: 'capistrano/rvm'
  gem 'capistrano-bundler'
  gem 'capistrano-rails', '~> 1.1.0'
  gem 'capistrano-rails-console'
  gem 'whenever'
end

group :production do
  gem 'exception_notification'
end

group :development do
  gem 'pry-stack_explorer'
  gem 'habtm_generator'
  gem 'thin'
  gem 'better_errors'
  gem 'binding_of_caller', :platforms=>[:mri_19, :mri_20, :rbx]
  gem 'guard-rspec'
  # gem 'haml-rails'
  gem 'foreman'
  gem 'haml2slim'
  gem 'html2haml'
  gem 'quiet_assets'
  gem 'rb-inotify', :require=>false
  # gem 'rack-mini-profiler'
end

group :development, :test do
  gem 'fabrication'
  gem 'rspec-rails', '~> 3.0.0.beta1'
end
group :test do
  gem 'capybara', '~>2.2.0.rc1'
  # gem 'poltergeist'
  gem 'vcr'
  gem 'webmock'
  gem 'simplecov', require: false
end
