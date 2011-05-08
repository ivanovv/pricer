class ScrapedConfiguration < ActiveRecord::Base
  attr_accessible :company_id, :name, :url, :assembly_price, :total_price

  belongs_to :company

  validates :company_id, :presence => true

  has_many :prices, :through => :configuration_lines
  has_many :configuration_lines

  before_validation  :parse_configuration

  private
  def parse_configuration
    Rails.logger.debug "url = #{self.url}"
    configuration_parser = ConfigurationScraperFactory.create_scraper(url)
    configuration_parser.parse(self)
  end

end
