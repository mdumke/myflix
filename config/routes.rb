Myflix::Application.routes.draw do
  root 'sessions#front'

  get 'ui(/:action)', controller: 'ui'
  get 'home', to: 'videos#index'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy'
  get 'register', to: 'users#new'
  get 'register/:token', to: 'users#new_with_invitation_token',
                         as: 'register_with_invitation_token'

  get 'my_queue', to: 'queue_items#index'
  patch 'my_queue/update', to: 'queue_items#update_queue'
  get 'people', to: 'relationships#index'

  resources :categories, only: [:show]

  resource :forgot_password, only: [:new, :create] do
    get :confirm, on: :collection
  end

  resources :invitations, only: [:new, :create]

  resources :password_resets, only: [:show, :update]
  get 'invalid_token', to: 'pages#invalid_token'

  resources :queue_items, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
  resources :users, only: [:show, :create]

  resources :videos, only: [:index, :show] do
    get 'search', on: :collection
    post 'review', on: :member
  end

  require 'sidekiq/web'
  require 'login_constraint'
  mount Sidekiq::Web => '/workers', constraints: LoginConstraint.new
end

