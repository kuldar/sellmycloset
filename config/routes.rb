Rails.application.routes.draw do

	# Users
  devise_for :users, 
    controllers: { omniauth_callbacks: 'users/omniauth_callbacks', registrations: 'registrations' },
    path_names: { sign_in: 'signin', sign_up: 'join', }

  resources  :users, path: 'u', only: :show
  resources	 :users, path: 'u' do
    member do
      get :following, :followers
    end
  end

  # Admin
  namespace :admin do
    resources :products
    resources :users
    resources :transactions
    root to: "products#index"
  end

  # Root
	root 'static_pages#home'
  get :join, to: 'static_pages#join'

	# Products
  resources :products, path: 'p', only: [:show, :edit, :update]
	resources :products do
    resource :like, module: :products
    resources :comments
    resource :transaction
  end

  # Product Images
  resources :product_images, only: [:create, :destroy]

  # Relationships
  resources :relationships, only: [:create, :destroy]

  # Static pages
  get :become_seller, to: 'static_pages#become_seller'
  put :become_seller, to: 'users#become_seller'

end
