class ProductImage < ApplicationRecord

	mount_uploader :image, ProductImageUploader
	validates_presence_of :image

	belongs_to :product
	
end