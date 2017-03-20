# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160907180705) do

  create_table "comments", force: :cascade do |t|
    t.text     "body"
    t.integer  "user_id"
    t.integer  "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_comments_on_product_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "likes", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "product_images", force: :cascade do |t|
    t.text    "image_data"
    t.integer "product_id"
  end

  create_table "products", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
    t.string   "size"
    t.integer  "category"
    t.integer  "status",         default: 1
    t.integer  "user_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "price_cents",    default: 0,     null: false
    t.string   "price_currency", default: "EUR", null: false
    t.index ["user_id", "created_at"], name: "index_products_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_products_on_user_id"
  end

  create_table "relationships", force: :cascade do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["followed_id"], name: "index_relationships_on_followed_id"
    t.index ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true
    t.index ["follower_id"], name: "index_relationships_on_follower_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.integer  "status",                  default: 1
    t.integer  "seller_id"
    t.integer  "buyer_id"
    t.integer  "product_id"
    t.string   "shipping_target"
    t.float    "payout_margin"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.integer  "product_price_cents",     default: 0,     null: false
    t.string   "product_price_currency",  default: "EUR", null: false
    t.integer  "shipping_price_cents",    default: 0,     null: false
    t.string   "shipping_price_currency", default: "EUR", null: false
    t.index ["buyer_id"], name: "index_transactions_on_buyer_id"
    t.index ["product_id", "buyer_id", "seller_id"], name: "index_transactions_on_product_id_and_buyer_id_and_seller_id", unique: true
    t.index ["product_id"], name: "index_transactions_on_product_id"
    t.index ["seller_id"], name: "index_transactions_on_seller_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                      default: "",    null: false
    t.string   "encrypted_password",         default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",              default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.string   "name"
    t.string   "username"
    t.integer  "role",                       default: 1
    t.text     "cover_data"
    t.text     "avatar_data"
    t.text     "about"
    t.string   "phone_number"
    t.string   "instagram_handle"
    t.string   "facebook_handle"
    t.float    "payout_margin"
    t.string   "payout_name"
    t.string   "payout_iban"
    t.string   "uid"
    t.string   "provider"
    t.string   "braintree_customer_id"
    t.integer  "available_balance_cents",    default: 0,     null: false
    t.string   "available_balance_currency", default: "EUR", null: false
    t.integer  "pending_balance_cents",      default: 0,     null: false
    t.string   "pending_balance_currency",   default: "EUR", null: false
    t.integer  "total_earnings_cents",       default: 0,     null: false
    t.string   "total_earnings_currency",    default: "EUR", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
