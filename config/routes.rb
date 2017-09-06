Rails.application.routes.draw do
  
  devise_for :users, :controllers => { omniauth_callbacks: 'omniauth_callbacks' }

  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup
  
  root to: 'sessions#new'

  get "/auth/:provider/callback", to: "sessions#create"

  delete 'signout', to: 'sessions#destroy', as:'signout'

  resources :users,  only: [:create]

  get '/main', to: 'main#index'

  namespace :hooks do
    namespace :google do
      post '/reception', to: 'reception#received'
    end
    namespace :slack do
      post '/reception', to: 'reception#received'
    end
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
