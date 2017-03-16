class AddColumnsToUsers < ActiveRecord::Migration[5.0]
  def change
    change_table :users do |t|
      t.string  :name
      t.string  :username, unique: true
      t.integer :role, default: 0
      t.string  :avatar
      t.string  :cover
      t.text    :about
      t.string  :phone_number
      t.string  :instagram_handle
      t.string  :facebook_handle
      t.string  :payout_name
      t.string  :payout_iban
      t.string  :uid
      t.string  :provider
      t.string  :braintree_customer_id
      t.integer :balance, default: 0
      t.integer :total_earnings, default: 0
    end
  end
end
