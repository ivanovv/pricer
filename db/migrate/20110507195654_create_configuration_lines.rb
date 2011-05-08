class CreateConfigurationLines < ActiveRecord::Migration
  def self.up
    create_table :configuration_lines do |t|
      t.integer :scraped_configuration_id
      t.integer :price_id
      t.integer :quantity
      t.integer :price_value
      t.string :description
      t.timestamps
    end
  end

  def self.down
    drop_table :configuration_lines
  end
end
