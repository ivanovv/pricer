class ChangePriceHistoryPriceToValue < ActiveRecord::Migration
  def self.up

    remove_column :price_histories, :price
    add_column :price_histories, :value, :integer
  end

  def self.down
    add_column :price_histories, :price, :integer
    remove_column :price_histories, :value, :integer
  end
end

