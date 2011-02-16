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

ActiveRecord::Schema.define(:version => 20110206104110) do

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cross_prices", :id => false, :force => true do |t|
    t.integer "price_id",       :null => false
    t.integer "cross_price_id", :null => false
  end

  add_index "cross_prices", ["price_id", "cross_price_id"], :name => "cross_price_uniq_columns", :unique => true

  create_table "items", :force => true do |t|
    t.string   "description"
    t.string   "original_description"
    t.string   "vendor_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "links", :force => true do |t|
    t.integer  "item_id"
    t.integer  "price_id"
    t.boolean  "human"
    t.integer  "score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "price_histories", :force => true do |t|
    t.integer  "price_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "value"
  end

  create_table "prices", :force => true do |t|
    t.integer  "company_id"
    t.string   "warehouse_code"
    t.string   "description"
    t.integer  "price"
    t.string   "original_description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "vendor_code"
  end

  add_index "prices", ["company_id", "original_description"], :name => "company_original_description_index"
  add_index "prices", ["company_id", "warehouse_code"], :name => "company_warehouse_code_index"
  add_index "prices", ["original_description"], :name => "original_description_index"
  add_index "prices", ["warehouse_code"], :name => "warehouse_code_index"

end
