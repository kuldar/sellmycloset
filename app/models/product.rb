class Product < ApplicationRecord
  acts_as_taggable

	enum status: {
    draft:      0,
    active:     1,
    sold: 			2,
    cancelled: 	3
  }

  mount_uploader :photo, PictureUploader

  belongs_to :user
  has_many :likes
  has_many :comments

  default_scope -> { order(created_at: :desc) }

  validates :user_id, presence: true
  validates :photo, :title, :description, :price, presence: true

end