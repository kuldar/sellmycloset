class Product < ApplicationRecord

	enum status: {
    draft:      0,
    active:     1,
    sold: 			2,
    deleted:    3
  }

  enum condition: {
    used:    0,
    unused:  1
  }

  enum category: {
    tops:         0,
    tshirts:      1,
    shirts:       2,
    dresses:      3,
    knitwear:     4,
    jackets:      5,
    coats:        6,
    trousers:     7,
    jumpsuits:    8,
    skirts:       9,
    nightwear:    10,
    lingerie:     11,
    swimwear:     12,
    shoes:        13,
    bags:         14,
    accessories:  15
  }

  is_impressionable counter_cache: true, unique: true

  belongs_to :user

  has_many  :product_images, dependent: :destroy

  has_many  :likes, dependent: :destroy
  has_many  :liked_users, through: :likes, source: :user

  has_many  :comments, dependent: :destroy
  has_many  :commented_users, through: :comments, source: :user

  has_one   :sale, foreign_key: 'product_id', class_name: 'Transaction'

  default_scope { order(created_at: :desc) }
  scope :in_category, lambda { |category| where(category: category) }
  scope :active, -> { where(status: :active) }

  monetize :price_cents, numericality: { greater_than_or_equal_to: 5 }

  validates :title,
            :description,
            :price_cents,
            :user_id,
            :category,
              presence: true

  before_destroy :clear_notifications

  def earnings_cents
    earnings = total_price_cents * self.user.payout_margin
  end

  def total_price_cents
    price_cents + shipping_price_cents
  end

  def total_price
    total_price_cents/100
  end

  def shipping_price_cents
    300
  end

  def shipping_price
    shipping_price_cents/100
  end

  private

    def clear_notifications
      Notification.where(notifiable: self).destroy_all
    end

end