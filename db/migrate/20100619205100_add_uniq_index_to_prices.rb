class AddUniqIndexToPrices < ActiveRecord::Migration
  def self.up
     add_index(:cross_prices, [:price_id, :cross_price_id], :name => "cross_price_uniq_columns", :unique => true)
  end

  def self.down
     add_index(:prices, [:price_id, :cross_price_id])
  end
end

