Podfilter::Application.routes.draw do
  admin_constraint = lambda do |request|
    request.session[:owner_id] && Owner.where(admin: true).where(id: request.session[:owner_id]).any?
  end

  post 'opml/create', to: 'opml_files#create'
  get  'opml/:id', to: 'opml_files#show', as: :opml_file
  post 'opml/:id/add/:source_id' => 'opml_files#add_source', as: :add_source_to_opml
  post 'opml/:id/remove/:source_id' => 'opml_files#remove_source', as: :remove_source_from_opml

  delete 'opml/:id' => 'opml_files#destroy'

  get 'admin' => 'admin#index'
  get 'admin/duplicates'
  post 'admin/merge'

  constraints(:format => :html) do
    get "impressum" => 'pages#impress'
    get 'browse/most-popular'     => 'podcasts#index', order: :most
    get 'browse/recently-updated' => 'podcasts#index', order: :recent
    # get 'browse/most', 'postcasts#index', order: :most

    get 'podcasts/category/:category_id' => 'podcasts#index', as: :category
    resources :podcasts, only: [:index, :show] do
      resources :sources, only: :show
    end
  end

  # get '/auth/:provider/callback', to: 'sessions#create', as: :omniauth_provider
  get 'abmelden' => 'sessions#destroy'
  get 'dashboard' => 'dashboard#index', as: :dashboard
  namespace :dashboard do
    resources :opml_files
  end
  get 'recommendations/:owner_id/feed' => 'pages#recommendation_feed', as: :recommendation_feed

  resources :change_requests do
    collection do
      get :apply
      patch :apply, action: 'apply_submit'
    end
  end

  if Rails.env.development?
    get 'uploads/podcast/:style/:id/:foo' => 'pages#not_found'
  end

  get 'api/v1' => 'pages#api_doc'
  mount V1, at: '/api/v1'

  constraints admin_constraint do
    require 'sidekiq/web'
    mount Sidekiq::Web, at: '/sidekiq'
    mount Logster::Web, at: '/logs'
  end

  root 'pages#index'
end
