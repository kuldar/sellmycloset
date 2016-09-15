class AddInfoToUsers < ActiveRecord::Migration[5.0]
  def change
  	add_column :users, :payment_name, :string
  	add_column :users, :payment_iban, :string
  	add_column :users, :payment_balance, :integer, default: 0
  	add_column :users, :lifetime_balance, :integer, default: 0
  	add_column :users, :country, :string
  end
end
