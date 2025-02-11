Rails.application.routes.draw do
  get "dashboard/index"
  resource :session, only: [:new, :create, :destroy]
  resources :passwords, param: :token
  
  # Add authentication routes
  resource :registration, only: [:new, :create] # For sign-up
  get "/sign_up", to: "registrations#new", as: :sign_up
  post "/sign_up", to: "registrations#create"
  get "/sign_in", to: "sessions#new", as: :sign_in
  delete "/logout", to: "sessions#destroy", as: :logout
  get "/dashboard", to: "dashboard#index", as: :dashboard
  
  # Define the root path route ("/")
  root "dashboard#index" # Change to your actual home page controller
end
