Podfilter::Application.routes.draw do
  get "impressum" => 'pages#impress'
  post 'opml/create', to: 'opml_files#create'
  # resources :opml_files

  resources :sources
  root 'pages#index'

end
