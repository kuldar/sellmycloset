class ShippingTarget < ApplicationRecord

  has_many :shipments, foreign_key: 'shipping_target_id', class_name: 'Transaction'
  scope :in_estonia, -> { where(country: :EE) }

end