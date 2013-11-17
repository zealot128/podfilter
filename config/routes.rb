Podfilter::Application.routes.draw do
  get "impressum" => 'pages#impress'
  post 'opml/create', to: 'opml_files#create'
  get  'opml/:id', to: 'opml_files#show', as: :opml_file

  delete 'opml/:id' => 'opml_files#destroy'

  resources :sources
  get 'dashboard' => 'pages#dashboard', as: :dashboard
  root 'pages#index'

  if Rails.env.development?
    require 'sidekiq/web'
    mount Sidekiq::Web, at: '/sidekiq'
  end
end
