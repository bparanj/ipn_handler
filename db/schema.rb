# encoding: UTF-8
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120723063307) do

  create_table "accounts", :force => true do |t|
    t.string   "primary_paypal_email"
    t.string   "custom"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "orders", :force => true do |t|
    t.string   "status",     :default => "open"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "payments", :force => true do |t|
    t.string   "transaction_id"
    t.decimal  "gross",          :precision => 8, :scale => 2
    t.string   "currency"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.decimal  "amount",         :precision => 8, :scale => 2
    t.string   "payment_method"
    t.string   "description"
    t.string   "status"
    t.string   "test"
    t.string   "payer_id"
  end

end
