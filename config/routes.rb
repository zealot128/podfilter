Podfilter::Application.routes.draw do
  get "impressum" => 'pages#impress'
  post 'opml/create', to: 'opml_files#create'
  get  'opml/:id', to: 'opml_files#show', as: :opml_file

  resources :sources
  get 'dashboard' => 'pages#dashboard', as: :dashboard
  root 'pages#index'

end
