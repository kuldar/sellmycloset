class ProductImage < ApplicationRecord

  include ProductImageUploader[:image]
  validates_presence_of :image_data
	
end