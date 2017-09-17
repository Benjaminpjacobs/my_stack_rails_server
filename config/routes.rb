Rails.application.routes.draw do
  
  devise_for :users, :controllers => { omniauth_callbacks: 'omniauth_callbacks', sessions: 'sessions/sessions' }

  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup
  
  root to: 'sessions#new'

  get "/auth/:provider/callback", to: "sessions#create"

  delete 'signout', to: 'sessions#destroy', as:'signout'

  resources :users,  only: [:create]

  get '/main', to: 'main#index'

  get '/hooks', to: 'hooks#index'
  namespace :hooks do
    namespace :google do
      post '/reception', to: 'reception#received'
      resources :broadcast, only: [:new]
      match 'broadcast/destroy' => 'broadcast#delete', :via => :get
    end

    namespace :slack do
      post '/reception', to: 'reception#received'
      match 'broadcast/destroy' => 'broadcast#delete', :via => :get
    end
    
    namespace :facebook do
      post '/reception', to: 'reception#received'
    end
    
    namespace :github do
      post '/reception', to: 'reception#received'
      resources :broadcast, only: [:new]
      match 'broadcast/update' => 'broadcast#update', :via => :get
      match 'broadcast/destroy' => 'broadcast#delete', :via => :get
    end
  end

  namespace :pings do
    get '/server', to: 'messages#receive_ping'
    put '/server', to: 'messages#clear_stack'
    patch '/server', to: 'messages#mark_read'
  end
  
end
