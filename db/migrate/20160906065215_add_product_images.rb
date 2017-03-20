class AddProductImages < ActiveRecord::Migration[5.0]
  def change
    create_table :product_images do |t|
      t.text    :image_data
      t.integer :product_id
    end
  end
end
