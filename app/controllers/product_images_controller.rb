class ProductImagesController < ApplicationController

	def create
		params[:product_images].each do |image|
			@product_image = ProductImage.create(image: image)
			if @product_image.save
				respond_to do |format|
					format.html { render json: @product_image.to_jq_upload, content_type: 'text/html', layout: false }
					format.json { render json: @product_image.to_jq_upload }
				end
			else
				render json: { error: @product_image.errors.full_messages }, status: 304
			end
		end
	end

end