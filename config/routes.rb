Rails.application.routes.draw do

  get '/test', to: 'static_pages#test'

	# Users
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks', registrations: 'registrations' }

  resources	 :users do
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
	root 'products#index'

	# Products
	resources :products do
    resource :like, module: :products
    resources :comments
    resource :transaction
  end

  # Product Images
  resources :product_images, only: [:create]

  # Relationships
  resources :relationships, only: [:create, :destroy]

  # Static pages
  get :become_seller, to: 'static_pages#become_seller'

<<<<<<< Updated upstream
  get '/.well-known/acme-challenge/sD-oifpWzh77olnVSCvltu4EBzCpjuQyJQqexCebsD0', to: 'static_pages#ssl'
  get '/.well-known/acme-challenge/WQ7QiV8Wo4W5RxXufpZA0fc2dk_tErc2HCI3M0PNN5g', to: 'static_pages#ssl2'

=======
>>>>>>> Stashed changes
end
