class ProductImage < ApplicationRecord

  include ProductImageUploader[:image]
	belongs_to :product, inverse_of: :product_images
  validates_presence_of :image_data
	
end