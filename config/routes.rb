Rails.application.routes.draw do
  get 'editor/refresh_sketch'

  get 'editor/show'

  root 'static_pages#home'

  get 'password_resets/new'
  get 'password_resets/edit'
  get 'sessions/new'
  get '/about', to: 'static_pages#about'
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  get '/login', to: 'sessions#new'
  get '/refresh-sketch', to: 'editor#refresh_sketch', defaults: { format: 'json' }
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :sketches
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :microposts, only: [:create, :destroy]
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :relationships, only: [:create, :destroy]
end
