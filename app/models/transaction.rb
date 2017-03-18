class Transaction < ApplicationRecord

  enum status: {
    sold:     0,
    shipped:  1,
    received: 2
  }

	belongs_to :product
	belongs_to :buyer, class_name: 'User'
	belongs_to :seller, class_name: 'User'

  validates :product_id, :seller_id, :buyer_id, :payout_margin, :product_price, :shipping_price, :shipping_target, presence: true
  monetize :product_price_cents, :shipping_price_cents

end