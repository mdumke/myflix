Myflix::Application.routes.draw do
  root 'sessions#front'

  get 'ui(/:action)', controller: 'ui'
  get 'home', to: 'videos#index'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy'
  get 'register', to: 'users#new'
  get 'forgot_password', to: 'users#forgot_password'
  post 'send_password_reset_link', to: 'users#send_password_reset_link'
  get 'confirm_password_reset', to: 'users#confirm_password_reset'
  get 'reset_password/:id', to: 'users#reset_password_form', as: 'reset_password_form'
  post 'reset_password', to: 'users#reset_password', as: 'reset_password'
  get 'invalid_token', to: 'users#invalid_token'

  get 'my_queue', to: 'queue_items#index'
  patch 'my_queue/update', to: 'queue_items#update_queue'
  get 'people', to: 'relationships#index'

  resources :categories, only: [:show]
  resources :queue_items, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
  resources :users, only: [:show, :create]

  resources :videos, only: [:index, :show] do
    get 'search', on: :collection
    post 'review', on: :member
  end
end
