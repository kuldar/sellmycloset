class ProductImagesController < ApplicationController

	def create
		params[:product_images].each do |image|
			@product_image = ProductImage.create(image: image)
			@product_image.save
		end
	end

end