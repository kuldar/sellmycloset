class Product < ApplicationRecord

	enum status: {
    draft:      0,
    active:     1,
    sold: 			2,
    deleted:    3
  }

  enum category: {
    other:      0,
    shirt:      1,
    sweater:    2,
    jacket:     3,
    coat:       4,
    pants:      5,
    skirt:      6,
    dress:      7,
    shoes:      8,
    accessory:  9
  }

  belongs_to :user
  has_many  :likes
  has_many  :liked_users, through: :likes, source: :user

  has_many  :comments, dependent: :destroy
  has_many  :commented_users, through: :comments, source: :user

  has_one   :sale, foreign_key: 'product_id', class_name: 'Transaction'
  
  has_many  :product_images, dependent: :destroy
  # accepts_nested_attributes_for :product_images, allow_destroy: true
  # validates :product_images, presence: true

  # default_scope { where(status: :active).order(created_at: :desc) }
  default_scope { order(created_at: :desc) }
  scope :in_category, lambda { |category| where(category: category) }

  validates :title, :description, :price_cents, :user_id, :category, presence: true
  monetize :price_cents, numericality: { greater_than_or_equal_to: 5 }

  # def earnings
  #   price * MARGIN
  # end

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

end