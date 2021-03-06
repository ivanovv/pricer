class CreateLinks < ActiveRecord::Migration
  def self.up
    create_table :links do |t|
      t.integer :item_id
      t.integer :price_id
      t.boolean :human
      t.integer :score
      t.timestamps
    end
  end

  def self.down
    drop_table :links
  end
end
