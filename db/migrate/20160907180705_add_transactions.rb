class AddTransactions < ActiveRecord::Migration[5.0]
  def change
  	create_table :transactions do |t|
		  t.integer :seller_id
		  t.integer :buyer_id
		  t.integer :product_id

		  t.timestamps
		end

		add_index :transactions, [:seller_id, :buyer_id, :product_id], unique: true
  end
end
