class User < ApplicationRecord

	VALID_SLUG_REGEX = /\A[a-zA-Z0-9]*\z/

  enum role: {
    buyer:  0,
    seller: 1,
    editor: 2,
    admin:  3
  }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  mount_uploader :avatar, PictureUploader
         
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
