class Company < ActiveRecord::Base
  has_many :prices

  def make_short_link(full_link)
    if full_link
      full_link.sub(self.base_product_link, "")
    end    
  end
end

