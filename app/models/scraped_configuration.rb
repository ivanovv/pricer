class ScrapedConfiguration < ActiveRecord::Base
  attr_accessible :company_id, :name, :url, :assembly_price, :total_price, :created_at

  belongs_to :company
  validates :company_id, :presence => true

  has_many :prices, :through => :configuration_lines
  has_many :configuration_lines

  def self.create_from_config_url(url)
    scraped_configuration = self.new(:url => url)
    config = ConfigurationScraperFactory.create_scraper(url).parse(url)
    valid = ConfigurationSaver.save(scraped_configuration, config)
    [scraped_configuration, valid]
  end

end
