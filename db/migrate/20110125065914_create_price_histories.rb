class CreatePriceHistories < ActiveRecord::Migration
  def self.up
    create_table :price_histories do |t|
      t.integer :price_id
      t.integer :price
      t.timestamps
    end
  end

  def self.down
    drop_table :price_histories
  end
end
