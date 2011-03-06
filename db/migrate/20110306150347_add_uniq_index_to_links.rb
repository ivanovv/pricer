class AddUniqIndexToLinks < ActiveRecord::Migration
  def self.up
    add_index(:links, [:price_id, :item_id], :unique => true)
  end

  def self.down
    remove_index(:links, :column =>[:price_id, :item_id])
  end
end
