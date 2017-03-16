class Product < ApplicationRecord
  MARGIN = 0.8

	enum status: {
    draft:      0,
    active:     1,
    sold: 			2,
    cancelled:  3
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

  default_scope { order(created_at: :desc) }
  validates :title, :description, :price, :user_id, :category, presence: true

  def earnings
    price * MARGIN
  end

  def shipping_cost
    300
  end

  def total_cost
    price + shipping_cost
  end

end