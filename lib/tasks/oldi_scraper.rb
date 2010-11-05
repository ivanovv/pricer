# encoding: UTF-8

namespace :scrape do

  desc "Scrape Oldi config"
  task :oldi => :environment do
    agent = Mechanize.new
    #page = agent.get('http://www.citilink.ru/login/')
    page = agent.get('http://www.oldi.ru/catalog/configurator/?edit_order=127151')
    page.search('.componentstype').each do |comp|
      puts comp.search('.compid').text if comp.search('.compid')
    end
  end
end

