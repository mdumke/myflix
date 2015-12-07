Myflix::Application.routes.draw do
  root 'sessions#front'

  get 'ui(/:action)', controller: 'ui'
  get 'home', to: 'videos#index'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy'
  get 'register', to: 'users#new'

  get 'my_queue', to: 'queue_items#index'
  patch 'my_queue/update', to: 'queue_items#update_queue'
  get 'people', to: 'relationships#index'

  resources :categories, only: [:show]

  resource :forgot_password, only: [:new, :create] do
    get :confirm, on: :collection
  end

  resources :password_resets, only: [:show, :update]
  get 'invalid_token', to: 'password_resets#token_invalid'

  resources :queue_items, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
  resources :users, only: [:show, :create]

  resources :videos, only: [:index, :show] do
    get 'search', on: :collection
    post 'review', on: :member
  end
end
