class ConfigurationScraperFactory

  def self.create_scraper(url)
    Rails.logger.debug "URL = #{url}"

    #http://www.fcenter.ru/sb_config?strConfig=1%7C89166%3A1%7C84970%3A1%7C94268%3A1%7C89766%3A1%7C
    if url =~ /http:\/\/www\.fcenter\.ru\/sb_config.*/
      return Scrapers::FcenterScraper.new
    end

    #http://www.oldi.ru/catalog/configurator/?edit_order=127151
    if url =~ /http:\/\/www\.oldi\.ru\/catalog\/configurator\/\?edit_order=\d+/
      return Scrapers::OldiScraper.new
    end

    #http://www.citilink.ru/configurator/q515595/
    if url =~ /http:\/\/www\.citilink\.ru\/configurator\/q\d+\//
      return Scrapers::CitylinkScraper.new
    end

    #http://www.meijin.ru/glrproddscr?baseid=1020959
    if url =~ /http:\/\/www.meijin.ru\/glrproddscr\?baseid=\d+/
      return Scrapers::MeijinScraper.new
    end

    raise "Unknown configuration!"

  end
end