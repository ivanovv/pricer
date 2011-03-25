class AddCreatedAtIndexToPriceHistories < ActiveRecord::Migration
  def self.up
    add_index(:price_histories, [:price_id, :created_at])
  end

  def self.down
    remove_index(:price_histories, :column =>[:price_id, :created_at])
  end
end
