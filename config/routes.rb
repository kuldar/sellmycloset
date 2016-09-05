Rails.application.routes.draw do

	# Users
  devise_for :users
  resources	 :users

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

end
