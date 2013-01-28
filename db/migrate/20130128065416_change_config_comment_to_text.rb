class ChangeConfigCommentToText < ActiveRecord::Migration
  def up
    change_column :scraped_configurations, :comment, :text
  end

  def down
    change_column :scraped_configurations, :comment, :string
  end
end
