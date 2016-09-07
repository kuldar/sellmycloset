Rails.application.routes.draw do

	# Users
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks', registrations: 'registrations' }
  # devise_scope :user do
  #   delete 'sign_out', to: 'devise/sessions#destroy', as: :destroy_user_session
  # end

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
	root 'products#index'

	# Products
	resources :products do
    resource :like, module: :products
    resources :comments
  end

  # Relationships
  resources :relationships, only: [:create, :destroy]

  # Static pages
  get :become_seller, to: 'static_pages#become_seller'

end
