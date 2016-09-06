class ProductImage < ApplicationRecord

	mount_uploader :image, ProductImageUploader
	belongs_to :product
	
	# validates :product, presence: true

	# def to_jq_upload
	# 	{
	# 		url: image.url,
	# 		delete_url: id,
	# 		picture_id: id,
	# 		delete_type: 'DELETE'
	# 	}.to_json
	# end

	# def picture=(val)
 #    if !val.is_a?(String) && valid?
 #      picture_will_change!
 #      super
 #    end
 #  end

end