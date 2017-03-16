class AddProducts < ActiveRecord::Migration[5.0]
  def change
  	create_table :products do |t|
  		t.string    	:title
  		t.string 	    :description
      t.string      :size
  		t.integer     :price
      t.integer     :category
  		t.integer     :status, default: 1
      t.belongs_to  :user, foreign_key: true

  		t.timestamps
  	end

    add_index :products, [:user_id, :created_at]
  end
end
