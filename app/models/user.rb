class User < ApplicationRecord

  include CoverUploader[:cover]
  include AvatarUploader[:avatar]

  DEFAULT_PAYOUT_MARGIN = 0.8
	VALID_SLUG_REGEX = /\A[a-zA-Z0-9]*\z/

  enum role: {
    admin:  0,
    buyer:  1,
    seller: 2
  }

  devise  :database_authenticatable, 
          :registerable,
          :recoverable, 
          :rememberable,
          :trackable,
          :validatable,
          :omniauthable,
          omniauth_providers: [:facebook]
         
	has_many :products, dependent: :destroy
  has_many :purchases, class_name: 'Transaction',
                                    foreign_key: 'buyer_id'
  has_many :sales, class_name: 'Transaction',
                                    foreign_key: 'seller_id'

  has_many :likes
  has_many :liked_products, through: :likes, source: :product
  has_many :comments, dependent: :destroy
  has_many :active_relationships,   class_name: 'Relationship',
                                    foreign_key: 'follower_id',
                                    dependent: :destroy
  has_many :passive_relationships,  class_name: 'Relationship',
                                    foreign_key: 'followed_id',
                                    dependent: :destroy

  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  has_many :notifications, foreign_key: :recipient_id

	validates :name, presence: true
	validates :username, format: { with: VALID_SLUG_REGEX },
                       uniqueness: { case_sensitive: false },
                       presence: true

  before_validation :set_username
  before_create     :set_avatar, :set_payout_margin
  after_commit      :subscribe_to_mailing_list, on: :create

  monetize :pending_balance_cents, :available_balance_cents, :total_earnings_cents

  def to_param
    username
  end

  # def feed
  #   following_ids = "SELECT followed_id FROM relationships
  #                    WHERE  follower_id = :user_id"
  #   Product.where("user_id IN (#{following_ids})
  #                    OR user_id = :user_id", user_id: id)
  # end

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

  def placeholder_avatar_url(identifier, size = 100)
    "https://api.adorable.io/avatars/#{size}/#{identifier.to_param}.png"
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

  def update_earnings(earnings_cents)
    update(
      pending_balance_cents: self.pending_balance_cents + earnings_cents,
      total_earnings_cents: self.total_earnings_cents + earnings_cents
    )
  end

  # def update_pending_balance(earnings)
  #   self.pending_balance_cents += earnings
  #   self.total_earnings_cents += earnings
  # end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create! do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name
      # user.remote_avatar_url = "#{auth.info.image.gsub('http:','https:')}?width=500&height=500"
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session['devise.facebook_data'] && session['devise.facebook_data']['extra']['raw_info']
        user.email = data['email'] if user.email.blank?
        user.username = data['name'].tr('^A-Za-z0-9', '').downcase
        user.name = data['name'] if user.name.blank?
      end
    end
  end

  private
    def set_username
      if self.username.blank?
        username = self.name.tr('^A-Za-z0-9', '').downcase
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
      # self.remote_avatar_url ||= placeholder_avatar_url(email, 500)
      # self.avatar = placeholder_avatar_url(email, 500)
    end

    def set_payout_margin
      self.payout_margin ||= DEFAULT_PAYOUT_MARGIN
    end

    def subscribe_to_mailing_list
      SubscribeUserToMailingListJob.perform_later(self)
    end

end
