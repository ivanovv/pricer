class User < ActiveRecord::Base
  attr_accessible :provider, :uid, :name, :email, :small_user_pic_url, :user_pic_url

  def self.create_with_omniauth(auth)
    begin
      create! do |user|
        user.provider = auth['provider']
        user.uid = auth['uid']
        if auth['user_info']
          user.name = auth['user_info']['name'] if auth['user_info']['name'] # Twitter, Google, Yahoo, GitHub
          user.email = auth['user_info']['email'] if auth['user_info']['email'] # Google, Yahoo, GitHub
          user.small_user_pic_url = auth['user_info']['image'] if auth['user_info']['image'] # VK
        end
        if auth['extra']['user_hash']
          user.name = auth['extra']['user_hash']['name'] if auth['extra']['user_hash']['name'] # Facebook
          user.email = auth['extra']['user_hash']['email'] if auth['extra']['user_hash']['email'] # Facebook
          user.user_pic_url = auth['extra']['user_hash']['photo_big'] if auth['extra']['user_hash']['photo_big'] # VK
        end
      end
    rescue Exception
      raise Exception, "cannot create user record"
    end
  end
end
