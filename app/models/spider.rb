class Spider < ActiveRecord::Base
  attr_accessible :url, :last_page
  belongs_to :company

  def parse_next_page
    spider = SpiderFactory.create_spider(company.name)
    page_number = last_page + 1
    spider.parse_page(page_number)
    #update_column("last_page", page_number)
    self.last_page = page_number
    save
  end
end
