class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.string :description
      t.string :original_description
      t.string :vendor_code
      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
