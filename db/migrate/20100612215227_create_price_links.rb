class CreatePriceLinks < ActiveRecord::Migration
  def self.up
    create_table :cross_prices, :id => false do |t|
      t.integer :price_id, :null => false
      t.integer :cross_price_id, :null => false
    end
  end

  def self.down
    drop_table :cross_price
  end
end

