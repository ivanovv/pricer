class Spider < ActiveRecord::Base
  attr_accessible :url, :last_page
  belongs_to :company

  def parse_next_page
    return unless enabled?
    spider = SpiderFactory.create_spider(company.name)
    self.last_page = spider.parse_page(last_page)
    save
  end
end
