class CreateShippingTargets < ActiveRecord::Migration[5.0]
  def change
    create_table :shipping_targets do |t|
      t.string :name
      t.string :code
      t.string :address
      t.string :city
      t.string :country
    end
  end
end
