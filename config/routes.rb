Rails.application.routes.draw do
  
  root to: 'sessions#new'
  get "/auth/:provider/callback", to: "sessions#create"
  delete 'signout', to: 'sessions#destroy', as:'signout'

  resources :users,  only: [:create]

  get '/main', to: 'main#index'


  namespace :hooks do
    namespace :github do
      post '/reception', to: 'reception#received'
      resources :broadcast, only: [:new, :create]
      match 'broadcast/edit' => 'broadcast#edit', :via => :get
      match 'broadcast/destroy' => 'broadcast#delete', :via => :delete
    end
  end

  namespace :pings do
    get '/server', to: 'messages#receive_ping'
    patch '/server', to: 'messages#mark_read'
  end
  
end
