Rails.application.routes.draw do
  get "books/index"
  get "books/show"
  get "books/new"
  get "books/create"
  get "books/edit"
  get "books/update"
  get "books/destroy"
  get "dashboard/index"
  resources :passwords, param: :token
  resources :books
  
  # Add authentication routes
  resource :registration, only: [:new, :create] # For sign-up
  get "/sign_up", to: "registrations#new", as: :sign_up
  post "/sign_up", to: "registrations#create"
  get "/sign_in", to: "sessions#new", as: :sign_in
  post "/sign_in", to: "sessions#create"
  delete "/logout", to: "sessions#destroy", as: :logout
  get "/dashboard", to: "dashboard#index", as: :dashboard
  
  # Define the root path route ("/")
  root "dashboard#index" # Change to your actual home page controller
end
