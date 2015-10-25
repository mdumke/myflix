Myflix::Application.routes.draw do
  root 'sessions#front'

  get 'ui(/:action)', controller: 'ui'
  get 'home', to: 'videos#index'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy'
  get 'register', to: 'users#new'

  get 'my_queue', to: 'queue_items#index'

  resources :categories, only: [:show]
  resources :queue_items, only: [:create]
  resources :users, only: [:create]

  resources :videos, only: [:index, :show] do
    get 'search', on: :collection
    post 'review', on: :member
  end
end
