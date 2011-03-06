class AddFoundManyItemsToPrice < ActiveRecord::Migration
  def self.up
    add_column :prices, :many_items_found, :boolean
  end

  def self.down
    remove_column :prices, :many_items_found
  end
end
