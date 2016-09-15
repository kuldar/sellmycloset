class Product < ApplicationRecord
  acts_as_taggable

  MARGIN = 0.7

	enum status: {
    draft:      0,
    active:     1,
    sold: 			2,
    cancelled:  3
  }

  enum category: {
    shirts:       1,
    sweaters:     2,
    jackets:      3,
    coats:        4,
    pants:        5,
    jeans:        6,
    skirts:       7,
    dresses:      8,
    shoes:        9,
    accessories: 10
  }

  belongs_to :user
  has_many :likes
  has_many :comments, dependent: :destroy
  has_one :sale, foreign_key: 'product_id', class_name: 'Transaction'
  
  has_many                      :product_images, dependent: :destroy
  accepts_nested_attributes_for :product_images, allow_destroy: true
  # validates :product_images, presence: true

  default_scope { order(created_at: :desc) }

  validates :title, :description, :price, :user_id, :category, presence: true

  # def next
  #   Product.where('id < ?', id).first
  # end

  # def prev
  #   Product.where('id > ?', id).last
  # end

  def earnings
    price * MARGIN
  end

  def shipping_cost
    3
  end

  def total_cost
    price + shipping_cost
  end

end