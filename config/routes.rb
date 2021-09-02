Rails.application.routes.draw do
  resources :sessions, only: [:new, :create, :destroy]
  root to: 'tasks#index'
  resources :tasks
  resources :tasks do
    get :search, on: :collection
  end

  resources :users, only: [:new, :create, :show]

  namespace :admin do
    resources :users
  end
end
