class SpiderFactory

  def self.create_spider(company)
    if company == "CityLink"
      return Spiders::CitylinkSpider.new
    end
    raise "Unknown spider for company '#{company}'."
  end

end