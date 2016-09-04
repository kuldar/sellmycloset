class Product < ApplicationRecord

	enum status: {
    draft:      0,
    active:     1,
    sold: 			2,
    cancelled: 	3
  }

  mount_uploader :photo, PictureUploader

  belongs_to :user
  has_many :likes
  validates :user_id, presence: true
  validates :photo, :title, :description, :price, presence: true

  def to_param
  	[id, title.parameterize].join('-')
  end

end