Podfilter::Application.routes.draw do
  get "impressum" => 'pages#impress'
  post 'opml/create', to: 'opml_files#create'
  get  'opml/:id', to: 'opml_files#show', as: :opml_file
  post 'opml/:id/add/:source_id' => 'opml_files#add_source'
  post 'opml/:id/remove/:source_id' => 'opml_files#remove_source'

  delete 'opml/:id' => 'opml_files#destroy'

  get 'admin/duplicates'
  post 'admin/merge'

  resources :sources

  get 'dashboard' => 'pages#dashboard', as: :dashboard
  root 'pages#index'

  require 'sidekiq/web'
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == ENV['SIDEKIQ_WEB_USER'] && password == ENV['SIDEKIQ_WEB_PASSWORD']
  end
  mount Sidekiq::Web, at: '/sidekiq'
end
