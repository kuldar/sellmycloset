class Product < ApplicationRecord
  # MARGIN = 0.8
  SHIPPING_COST_CENTS = 300

	enum status: {
    draft:      0,
    active:     1,
    sold: 			2,
    deleted:    3
  }

  enum category: {
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
  has_many  :comments, dependent: :destroy
  has_one   :sale, foreign_key: 'product_id', class_name: 'Transaction'
  
  has_many                      :product_images, dependent: :destroy
  accepts_nested_attributes_for :product_images, allow_destroy: true
  # validates :product_images, presence: true

  # default_scope { where(status: :active).order(created_at: :desc) }
  default_scope { order(created_at: :desc) }
  validates :title, :description, :price_cents, :user_id, :category, presence: true
  monetize :price_cents, numericality: { greater_than_or_equal_to: 5 }

  # def earnings
  #   price * MARGIN
  # end

  def shipping_cost
    SHIPPING_COST_CENTS/100
  end

  def total_cost
    total_cost_cents/100    
  end

  def total_cost_cents
    price_cents + SHIPPING_COST_CENTS
  end

end