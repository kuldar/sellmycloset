class AddProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string      :title
      t.string      :description
      t.string      :size
      t.integer     :category
      t.string      :brand
      t.integer     :condition
      t.integer     :status, default: 1
      t.integer     :impressions_count, default: 0
      t.belongs_to  :user, foreign_key: true

      t.timestamps
    end

    add_index :products, [:user_id, :created_at]
    add_monetize :products, :price
  end
end
