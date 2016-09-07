class User < ApplicationRecord

	VALID_SLUG_REGEX = /\A[a-zA-Z0-9]*\z/

  enum role: {
    buyer:  0,
    seller: 1,
    brand:  2,
    editor: 3,
    admin:  4
  }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  mount_uploader :avatar, AvatarUploader
  mount_uploader :cover, CoverUploader
         
	has_many :products, dependent: :destroy
  has_many :likes
  has_many :comments
  has_many :active_relationships,   class_name: 'Relationship',
                                    foreign_key: 'follower_id',
                                    dependent: :destroy
  has_many :passive_relationships,  class_name: 'Relationship',
                                    foreign_key: 'followed_id',
                                    dependent: :destroy

  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

	validates :name, presence: true
  validates :name, presence: true
	validates :username, presence: true, 
                       format: { with: VALID_SLUG_REGEX },
                       uniqueness: { case_sensitive: false }

  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE  follower_id = :user_id"
    Product.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
  end

  def avatar_url
    try(:avatar) || placeholder_avatar(email)
  end

  def instagram_url
    "https://www.instagram.com/" + instagram_handle if instagram_handle
  end

  def facebook_url
    "https://www.facebook.com/" + facebook_handle if facebook_handle
  end

  def placeholder_avatar(email)
    "https://api.adorable.io/avatars/100/#{email.to_param}"
  end

  def likes?(product)
  	product.likes.where(user_id: id).any?
  end

  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end

end
