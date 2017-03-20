class ProductImagesController < ApplicationController

	def create
		@product_image = ProductImage.new(product_image_params)

		respond_to do |format|
			if @product_image.save
				format.json { render :show, status: :created, location: [@product, @product_image]}
			else
				format.json { render json: @product_image.errors, status: :unprocessable_entity }
			end
		end
	end

	def destroy
		@product_image = ProductImage.find(params[:id])
		@product_image.destroy!
		respond_to do |format|
			format.js
		end
	end

	private

		def product_image_params
			params.require(:product_image).permit(:image)
		end

end