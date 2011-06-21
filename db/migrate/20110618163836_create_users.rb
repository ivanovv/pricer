class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :provider
      t.string :uid
      t.string :name
      t.string :email
      t.string :user_pic_url
      t.string :small_user_pic_url
      
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
