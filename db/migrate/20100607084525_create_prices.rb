class CreatePrices < ActiveRecord::Migration
  def self.up
    create_table :prices do |t|
      t.integer :company_id
      t.string :warehouse_code
      t.string :description
      t.decimal :price
      t.string :original_description

      t.timestamps
    end
    add_index(:prices, "warehouse_code", :name => "warehouse_code_index")
  end

  def self.down
    drop_table :prices
  end
end

