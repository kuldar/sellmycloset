class AddColumnsToUsers < ActiveRecord::Migration[5.0]
  def change
  	add_column :users, :name, 						:string
  	add_column :users, :username, 				:string, unique: true
  	add_column :users, :about,					 	:text
  	add_column :users, :avatar, 					:string
  	add_column :users, :cover, 						:string
  	add_column :users, :instagram_handle, :string
  	add_column :users, :facebook_handle, 	:string
  	add_column :users, :role,		 					:integer, default: 0
    add_column :users, :braintree_customer_id, :string
  end
end
