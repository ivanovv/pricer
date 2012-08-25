class AddIndexToScrappedConfigurations < ActiveRecord::Migration
  def change
    add_index(:configuration_lines, [:scraped_configuration_id])
  end

  def self.down
    remove_index(:configuration_lines, [:scraped_configuration_id])
  end
end
