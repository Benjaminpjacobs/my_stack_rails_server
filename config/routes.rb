Rails.application.routes.draw do
  
  get "/auth/:provider/callback", to: "sessions#create"
  # get 'auth/failure', to redirect('/')
  delete 'signout', to: 'sessions#destroy', as:'signout'
  root to: 'sessions#new'
  resources :users,  only: [:create]

  namespace :hooks do
    post '/github', to: 'github#received'
    # get '/hook', to: 'hook#new', as: 'new'
    # post '/hook', to: 'hook#create'
    # get '/hook', to: 'hook#edit', as: "edit"
    # delete '/hook', to: 'hook#delete'
    resources :hook, only: [:new, :create]
    match 'hook/edit' => 'hook#edit', :via => :get
    match 'hook/destroy' => 'hook#delete', :via => :delete
  end

  
end
