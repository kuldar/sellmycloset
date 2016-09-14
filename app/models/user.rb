class User < ApplicationRecord

	VALID_SLUG_REGEX = /\A[a-zA-Z0-9]*\z/

  enum role: {
    buyer:  0,
    seller: 1,
    brand:  2,
    editor: 3,
    admin:  4
  }

  devise  :database_authenticatable, 
          :registerable,
          :recoverable, 
          :rememberable,
          :trackable,
          :validatable,
          :omniauthable,
          omniauth_providers: [:facebook]

  mount_uploader :avatar, AvatarUploader
  mount_uploader :cover, CoverUploader
         
	has_many :products, dependent: :destroy
  has_many :likes
  has_many :comments, dependent: :destroy
  has_many :active_relationships,   class_name: 'Relationship',
                                    foreign_key: 'follower_id',
                                    dependent: :destroy
  has_many :passive_relationships,  class_name: 'Relationship',
                                    foreign_key: 'followed_id',
                                    dependent: :destroy

  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

	validates :name, presence: true
	validates :username, format: { with: VALID_SLUG_REGEX },
                       uniqueness: { case_sensitive: false },
                       presence: true

  before_validation :set_username
  before_create :set_avatar

  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE  follower_id = :user_id"
    Product.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
  end

  def first_name
    if name.split.count > 1
      name.split[0..-2].join(' ')
    else
      name
    end
  end

  def last_name
    if name.split.count > 1
      name.split.last
    end
  end

  def instagram_url
    "https://www.instagram.com/" + instagram_handle if instagram_handle
  end

  def facebook_url
    "https://www.facebook.com/" + facebook_handle if facebook_handle
  end

  def placeholder_avatar_url(email)
    "https://api.adorable.io/avatars/100/#{email.to_param}"
    # "http://placehold.it/100x100"
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

  def has_payment_info?
    braintree_customer_id
  end

  def purchase(product)
    Transaction.create(
        product_id: product.id,
        buyer_id: id,
        seller_id: product.user.id
      )
  end

  def purchases
    # transactions_ids = "SELECT followed_id FROM relationships
    #                  WHERE  follower_id = :user_id"
    # Product.where("user_id IN (#{following_ids})
    #                  OR user_id = :user_id", user_id: id)
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create! do |user|
      user.email = auth.info.email
      user.name = auth.info.name
      user.remote_avatar_url = "#{auth.info.image.gsub('http:','https:')}?width=500&height=500"
      user.password = Devise.friendly_token[0,20]
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session['devise.facebook_data'] && session['devise.facebook_data']['extra']['raw_info']
        user.email = data['email'] if user.email.blank?
        user.username = data['name'].gsub(' ', '').downcase
        user.name = data['name'] if user.name.blank?
      end
    end
  end

  private
    def set_username
      if self.username.blank?
        username = self.name.gsub(' ','').downcase
        temp_username = username
        num = 1

        while(User.where(username: username).count > 0)
          username = "#{temp_username}#{num}"
          num += 1
        end

        self.username = username
      end
    end

    def set_avatar
      unless self.avatar?
        self.remote_avatar_url = placeholder_avatar_url(email)
      end
    end

end
