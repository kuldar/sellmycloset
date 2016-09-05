Rails.application.routes.draw do

	# Users
  devise_for :users
  resources	 :users do
    member do
      get :following, :followers
    end
  end

  # Admin
  namespace :admin do
    resources :products
    resources :users
    root to: "products#index"
  end

  # Root
	root 'static_pages#home'

	# Products
	resources :products do
    resource :like, module: :products
    resources :comments
  end

  # Relationships
  resources :relationships, only: [:create, :destroy]


end
