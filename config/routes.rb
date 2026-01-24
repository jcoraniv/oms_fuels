Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Session routes
  get "login" => "sessions#new", as: :login
  post "login" => "sessions#create"
  delete "logout" => "sessions#destroy", as: :logout
  post "set_gestion" => "sessions#set_gestion", as: :set_gestion
  get "select_gestion" => "sessions#select_gestion", as: :select_gestion

  # Defines the root path route ("/")
  root "sessions#new"

  namespace :admin do
    root 'dashboard#index'
    resources :users
    resources :personals
    resources :gestions
    resources :professions
    resources :positions
    resources :fuel_orders
    resources :vehicle_types
    resources :vehicles
    resources :fuels
  end
end
