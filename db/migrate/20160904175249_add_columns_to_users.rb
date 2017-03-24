class AddColumnsToUsers < ActiveRecord::Migration[5.0]
  def change
    change_table :users do |t|
      t.string  :name
      t.string  :username, unique: true
      t.integer :role, default: 1
      t.text    :cover_data
      t.text    :avatar_data
      t.text    :about
      t.string  :city
      t.string  :country
      t.string  :phone_number
      t.string  :instagram_handle
      t.string  :facebook_handle
      t.float   :payout_margin
      t.string  :payout_name
      t.string  :payout_iban
      t.string  :uid
      t.string  :provider
      t.string  :braintree_customer_id
      t.string  :braintree_last_4
      t.integer :shipping_target_id
    end

    add_monetize :users, :available_balance
    add_monetize :users, :pending_balance
    add_monetize :users, :total_earnings
  end
end
