Rails.application.routes.draw do
  
  get "/auth/:provider/callback", to: "sessions#create"
  # get 'auth/failure', to redirect('/')
  delete 'signout', to: 'sessions#destroy', as:'signout'
  root to: 'sessions#new'
  resources :users,  only: [:create]
  get '/main', to: 'main#index'


  namespace :hooks do
    post '/github', to: 'github#received'
    resources :hook, only: [:new, :create]
    match 'hook/edit' => 'hook#edit', :via => :get
    match 'hook/destroy' => 'hook#delete', :via => :delete
  end

  namespace :pings do
    get '/server', to: 'server#receive_ping'
  end
  
end
