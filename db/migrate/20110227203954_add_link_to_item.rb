class AddLinkToItem < ActiveRecord::Migration
  def self.up
    add_column :items, :web_link, :string
  end

  def self.down
    remove_column :items, :web_link
  end
end
