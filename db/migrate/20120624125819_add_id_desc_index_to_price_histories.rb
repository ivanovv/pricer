class AddIdDescIndexToPriceHistories < ActiveRecord::Migration
  def self.up
    remove_index(:price_histories, :column =>[:price_id, :created_at], :order => [:created_at => :desc])
    add_index(:price_histories, [:price_id, :id], :order => [:id => :desc])
  end

  def self.down
    remove_index(:price_histories, :column =>[:price_id, :id])
    add_index(:price_histories, [:price_id, :created_at])
  end
end
