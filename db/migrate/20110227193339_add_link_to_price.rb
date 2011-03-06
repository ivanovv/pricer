class AddLinkToPrice < ActiveRecord::Migration
  def self.up
    add_column :prices, :web_link, :string
  end

  def self.down
    remove_column :prices, :web_link
  end
end
