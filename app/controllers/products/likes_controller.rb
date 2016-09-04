class Products::LikesController < ApplicationController
	before_action :authenticate_user!
	before_action :set_product

	def create
		@product.likes.where(user_id: current_user.id).first_or_create

		respond_to do |format|
			format.html { redirect_to @product }
			format.js
		end
	end

	def destroy
		@product.likes.where(user_id: current_user.id).destroy_all
		respond_to do |format|
			format.html { redirect_to @product }
			format.js
		end
	end

	private

		def set_product
			@product = Product.find(params[:product_id])
		end

end