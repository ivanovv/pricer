class AddIndiciesToPrices < ActiveRecord::Migration
  def self.up
    add_index(:prices, %w{company_id warehouse_code}, :name => "company_warehouse_code_index")
    add_index(:prices, "original_description", :name => "original_description_index")
    add_index(:prices, %w{company_id original_description}, :name => "company_original_description_index")
  end

  def self.down
  end
end

