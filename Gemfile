source 'https://rubygems.org'
ruby '2.0.0'
gem 'rails', '4.0.1'
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'ruby-progressbar'
gem 'bootstrap-sass', '>= 3.0.0.0'
gem 'omniauth'
gem 'omniauth-twitter'
gem 'simple_form'
gem 'slim-rails'
gem 'pry-rails'
gem 'pg'
gem 'dotenv-rails'

group :development do
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
  gem 'rails_layout'
  gem 'rb-inotify', :require=>false
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
  gem 'coveralls', require: false
end
gem 'faraday'
gem 'feedzirra'
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


group :unrequired do
  gem 'capistrano', '~> 3.0.1'
  gem 'capistrano-rvm', '~> 0.0.3'
  gem 'capistrano-bundler'
  gem 'capistrano-rails', '~> 1.1.0'
  gem 'capistrano-rails-console'
  gem 'whenever'
end

group :production do
  gem 'exception_notification'
end
