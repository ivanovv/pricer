class CreateScrapedConfigurations < ActiveRecord::Migration
  def self.up
    create_table :scraped_configurations do |t|
      t.integer :company_id
      t.string :name
      t.string :url
      t.string :comment
      t.string :author
      t.integer :assembly_price
      t.integer :total_price
      t.timestamps
    end
  end

  def self.down
    drop_table :scraped_configurations
  end
end
