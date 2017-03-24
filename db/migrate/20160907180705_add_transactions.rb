class AddTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :transactions do |t|
      t.integer   :status, default: 1
      t.integer   :seller_id
      t.integer   :buyer_id
      t.integer   :product_id
      t.integer   :shipping_target_id
      t.float     :payout_margin
      t.datetime  :shipped_at
      t.datetime  :arrived_at
      t.datetime  :received_at

      t.timestamps
    end

    add_index :transactions, :product_id
    add_index :transactions, :seller_id
    add_index :transactions, :buyer_id
    add_index :transactions, [:product_id, :buyer_id, :seller_id], unique: true

    add_monetize :transactions, :product_price
    add_monetize :transactions, :shipping_price
  end
end
