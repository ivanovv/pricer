class SpiderFactory

  def self.create_spider(company)
    case company
      when "CityLink" then Spiders::CitylinkSpider.new
      when "Oldi" then Spiders::OldiSpider.new
      when "Meijin" then Spiders::MeijinSpider.new
      else
        raise "Unknown spider for company '#{company}'."
    end
  end
end