Rails.application.routes.draw do

	root 'static_pages#feed'
	get '/grid', to: 'static_pages#grid'
	get '/feed', to: 'static_pages#feed'
	get '/product', to: 'products#show'

end
