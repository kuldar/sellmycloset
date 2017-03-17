class UsersController < ApplicationController

	def index
		@users = User.all
	end

	def show
		@user = User.find_by_username(params[:id])
	end

	def following
		@title = "Following"
		@user = User.find(params[:id])
		@users = @user.following
		render 'show_follow'
	end

	def followers
		@title = "Followers"
		@user = User.find(params[:id])
		@users = @user.followers
		render 'show_follow'
	end

	def become_seller
		current_user.seller!
		flash[:success] = "Congrats, you're now a seller. :sparkles: <strong><a href='/products/new'>Add your first product!</a><strong>"
  	redirect_to root_path
	end

end
