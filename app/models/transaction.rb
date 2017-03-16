class Transaction < ApplicationRecord

  enum status: {
    sold:     0,
    shipped:  1,
    received: 2
  }

	belongs_to :product
	belongs_to :buyer, class_name: 'User'
	belongs_to :seller, class_name: 'User'

  validates :product_id, :seller_id, :buyer_id, :shipping_target, presence: true

end