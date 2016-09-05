class User < ApplicationRecord

	VALID_SLUG_REGEX = /\A[a-zA-Z0-9]*\z/

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  mount_uploader :avatar, PictureUploader
         
	has_many :products, dependent: :destroy
  has_many :likes
  has_many :comments

	validates :name, presence: true
	validates :username, presence: true, 
                       format: { with: VALID_SLUG_REGEX },
                       uniqueness: { case_sensitive: false }

  def likes?(product)
  	product.likes.where(user_id: id).any?
  end

end
