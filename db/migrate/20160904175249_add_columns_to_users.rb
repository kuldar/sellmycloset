class AddColumnsToUsers < ActiveRecord::Migration[5.0]
  def change
    change_table :users do |t|
      t.string  :name
      t.string  :username, unique: true
      t.integer :role, default: 1
      t.string  :avatar
      t.string  :cover
      t.text    :about
      t.string  :phone_number
      t.string  :instagram_handle
      t.string  :facebook_handle
      t.float   :payout_margin
      t.string  :payout_name
      t.string  :payout_iban
      t.string  :uid
      t.string  :provider
      t.string  :braintree_customer_id
    end

    add_money :users, :available_balance
    add_money :users, :pending_balance
    add_money :users, :total_earnings
  end
end
