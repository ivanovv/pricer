class AddVendorCodeToPrice < ActiveRecord::Migration
  def self.up
    add_column :prices, :vendor_code, :string
  end

  def self.down
    remove_column :prices, :vendor_code
  end
end

