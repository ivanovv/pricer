class CreateParsingResults < ActiveRecord::Migration
  def self.up
    create_table :parsing_results do |t|
      t.references :company
      t.integer :file_size
      t.datetime :started_at
      t.datetime :finished_at
      t.integer :all_rows
      t.integer :parsed_rows
      t.integer :created_rows
      t.integer :updated_rows
      t.string :errors_text
      t.string :extra_info

      t.timestamps
    end
  end

  def self.down
    drop_table :parsing_results
  end
end
