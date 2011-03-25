class AddFcenterCodeToItems < ActiveRecord::Migration
  def self.up
    add_column(:items, :fcenter_code, :string)
    add_index(:items, :fcenter_code)
  end

  def self.down
    remove_index(:items, :fcenter_code)
    remove_column(:items, :fcenter_code)
  end
end
