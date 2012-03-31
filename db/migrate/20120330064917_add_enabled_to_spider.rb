class AddEnabledToSpider < ActiveRecord::Migration
  def change
    add_column :spiders, :enabled, :boolean, :default => true
  end
end
