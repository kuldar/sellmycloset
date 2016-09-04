class AddProducts < ActiveRecord::Migration[5.0]
  def change
  	create_table :products do |t|
  		t.string  :photo
  		t.string 	:title
  		t.string 	:description
  		t.float   :price
  		t.integer :status
      t.belongs_to  :user, foreign_key: true

  		t.timestamps
  	end
  end
end
