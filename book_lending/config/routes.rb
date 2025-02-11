Rails.application.routes.draw do
  get "dashboard/index"

  # Borrowing Routes
  resources :borrows, only: [:index, :update]
  post "books/:book_id/borrow", to: "borrows#create", as: :book_borrow

  # Books Routes (Full RESTful routes)
  resources :books do
    post 'borrow', to: 'borrows#create'
  end

  # Password Reset Routes
  resources :passwords, param: :token

  # Authentication Routes
  resource :registration, only: [:new, :create] # For sign-up
  get "/sign_up", to: "registrations#new", as: :sign_up
  post "/sign_up", to: "registrations#create"
  get "/sign_in", to: "sessions#new", as: :sign_in
  post "/sign_in", to: "sessions#create"
  delete "/logout", to: "sessions#destroy", as: :logout

  # Dashboard Route
  get "/dashboard", to: "dashboard#index", as: :dashboard

  # Root Route
  root "dashboard#index"
end
