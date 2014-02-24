Podfilter::Application.routes.draw do
  get "impressum" => 'pages#impress'
  post 'opml/create', to: 'opml_files#create'
  get  'opml/:id', to: 'opml_files#show', as: :opml_file
  post 'opml/:id/add/:source_id' => 'opml_files#add_source', as: :add_source_to_opml
  post 'opml/:id/remove/:source_id' => 'opml_files#remove_source', as: :remove_source_from_opml

  delete 'opml/:id' => 'opml_files#destroy'

  get 'admin/duplicates'
  post 'admin/merge'

  get 'browse/most-popular'     => 'podcasts#index', order: :most
  get 'browse/recently-updated' => 'podcasts#index', order: :recent
  # get 'browse/most', 'postcasts#index', order: :most

  get 'podcasts/category/:category_id' => 'podcasts#index', as: :category
  resources :podcasts, only: [:index, :show] do
    resources :sources, only: :show
  end

  get '/auth/:provider/callback', to: 'sessions#create', as: :omniauth_provider
  get 'dashboard' => 'pages#dashboard', as: :dashboard
  get 'recommendations/:owner_id/feed' => 'pages#recommendation_feed', as: :recommendation_feed
  root 'pages#index'

  require 'sidekiq/web'
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == ENV['SIDEKIQ_WEB_USER'] && password == ENV['SIDEKIQ_WEB_PASSWORD']
  end
  mount Sidekiq::Web, at: '/sidekiq'
end
