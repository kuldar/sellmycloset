Rails.application.routes.draw do

  namespace :admin do
    resources :products

    root to: "products#index"
  end

	root 'products#index'

	# Products
	resources :products

end
