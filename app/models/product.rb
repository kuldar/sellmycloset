class Product < ApplicationRecord

	enum status: {
    draft:      0,
    active:     1,
    sold: 			2,
    cancelled: 	3
  }

  mount_uploader :photo, PictureUploader

  def to_param
  	[id, title.parameterize].join('-')
  end

end