class Product < ApplicationRecord
  acts_as_taggable

	enum status: {
    draft:      0,
    active:     1,
    sold: 			2,
    cancelled:  3
  }

  belongs_to :user
  has_many :likes
  has_many :comments, dependent: :destroy
  has_one :sale, foreign_key: 'product_id', class_name: 'Transaction'
  
  has_many                      :product_images, dependent: :destroy
  accepts_nested_attributes_for :product_images, allow_destroy: true
  # validates :product_images, presence: true

  default_scope -> { order(created_at: :desc) }

  validates :user_id, presence: true
  validates :title, :description, :price, presence: true

  def next
    Product.where('id < ?', id).first
  end

  def prev
    Product.where('id > ?', id).last
  end

  def shipping
    Rails.env.production? ? 0 : 0
  end

  def total_price
    price + shipping
  end

end