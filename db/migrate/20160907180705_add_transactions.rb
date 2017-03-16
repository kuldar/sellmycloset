class AddTransactions < ActiveRecord::Migration[5.0]
  def change
  	create_table :transactions do |t|
      t.integer :status, default: 1
		  t.integer :seller_id
		  t.integer :buyer_id
		  t.integer :product_id
		  t.string 	:shipping_target

		  t.timestamps
		end

		add_index :transactions, [:product_id], unique: true
  end
end
