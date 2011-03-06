class AddLinksToCompany < ActiveRecord::Migration
  def self.up
     add_column :companies, :base_product_link, :string
     add_column :companies, :home_link, :string
  end

  def self.down
    remove_column :companies, :base_product_link
    remove_column :companies, :home_link
  end
end
