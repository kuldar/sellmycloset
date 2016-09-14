class AddCategoryToProducts < ActiveRecord::Migration[5.0]
  def change
  	add_column :products, :category, :integer
  end
end
