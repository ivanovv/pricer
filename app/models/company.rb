class Company < ActiveRecord::Base
  has_many :prices
  has_many :scraped_configurations
  has_many :parsing_results

  def make_short_link(full_link)
    if full_link
      full_link.to_s.sub(self.base_product_link, "")
    end
  end
end

