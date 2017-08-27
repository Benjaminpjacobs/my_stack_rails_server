Rails.application.routes.draw do
  
  get "/auth/:provider/callback", to: "sessions#create"
  # get 'auth/failure', to redirect('/')
  delete 'signout', to: 'sessions#destroy', as:'signout'
  root to: 'sessions#new'
  resources :users,  only: [:create]

  namespace :hooks do
    post '/github', to: 'github#received'
    post '/hook', to: 'hook#create', as:'hook'
  end

  
end
