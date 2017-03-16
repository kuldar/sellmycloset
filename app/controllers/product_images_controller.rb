class ProductImagesController < ApplicationController

	def create
	end

	def destroy
		@product_image = ProductImage.find(params[:id])
		@product = @product_image.product
		@product_image.destroy!

		respond_to do |format|
			format.html { redirect_to @product }
			format.js
		end
	end

end