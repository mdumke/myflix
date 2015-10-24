Myflix::Application.routes.draw do
  root 'sessions#front'

  get 'ui(/:action)', controller: 'ui'
  get 'home', to: 'videos#index'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy'
  get 'register', to: 'users#new'

  resources :users, only: [:create]

  resources :videos, only: [:index, :show] do
    get 'search', on: :collection
    post 'review', on: :member
  end

  resources :categories, only: [:show]
end
