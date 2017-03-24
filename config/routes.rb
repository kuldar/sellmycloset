Rails.application.routes.draw do
  
  mount AvatarUploader::UploadEndpoint => '/avatars/upload'
  mount CoverUploader::UploadEndpoint => '/covers/upload'
  mount ProductImageUploader::UploadEndpoint => '/productimages/upload'

	# Users
  devise_for :users, 
    controllers: { omniauth_callbacks: 'users/omniauth_callbacks', registrations: 'registrations' },
    path_names: { sign_in: 'signin', sign_up: 'join', }

  resources	 :users, path: 'u' do
    member do
      get :following, :followers, :sales, :purchases, :likes
    end
  end

  # Ajax updating paths
  put '/users/avatar', to: 'users#avatar'
  put '/users/cover', to: 'users#cover'

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
  resources :products, path: 'p', except: :index
	resources :products, path: 'p' do
    resource :like, module: :products
    resources :comments
    resource :transaction
  end
  
  resources :products, path: 'products', only: :index

  # Product Images
  resources :product_images, only: [:create, :destroy]

  # Relationships
  resources :relationships, only: [:create, :destroy]

  # Shipping targets
  # resources :shipping_targets, only: [:index, :new, :create, :destroy]

  # Static pages
  get :seller_advice, to: 'static_pages#seller_advice'
  get :become_seller, to: 'static_pages#become_seller'
  put :become_seller, to: 'users#become_seller'

  # Sellers path
  get :sellers, to: 'users#sellers'

  # Remove CC
  put :remove_payment_method, to: 'users#remove_payment_method'

  # Notifications
  resources :notifications do
    collection do
      post :mark_as_read
    end
  end

end
