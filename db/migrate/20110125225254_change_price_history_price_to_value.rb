class ChangePriceHistoryPriceToValue < ActiveRecord::Migration
  def self.up

    remove_column :price_histories, :price
    add_column :price_histories, :value, :integer
  end

  def self.down
    add_column :price_histories, :price
    remove_column :price_histories, :value, :integer
  end
end

