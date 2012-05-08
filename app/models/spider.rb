class Spider < ActiveRecord::Base
  attr_accessible :url, :last_page
  belongs_to :company

  def parse_next_page
    return unless enabled?
    spider = SpiderFactory.create_spider(company.name)
    page_number = last_page + 1
    self.last_page = spider.parse_page(page_number)
    save
  end
end
