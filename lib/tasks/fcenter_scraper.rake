# encoding: UTF-8

namespace :scrape do

  desc "Scrape F-Center config"
  task :fcenter => :environment do
    str = "http://www.fcenter.ru/sb_config?strConfig=1|81672:2|81995:1|83172:2|90635:2|89521:2|"
    str = "http://www.fcenter.ru/sb_config?strConfig=2|83754:1|82233:1|83172:1|74874:2|80971:1|84953:1|84289:1|82068:1|67943:1|64803:1|83622:1|&count=1"
    a = str.split "|"

    a.each do |item|
      if item =~ /\d+\:\d+/
        matches = item.match(/(\d+)\:(\d+)/)
        company = Company.find_by_name("F-Center")
        price = company.prices.find_by_warehouse_code(matches[1])
        if price
          puts "item :: #{price.original_description} quantity :: #{matches[2]} price :: #{price.price}"
          price.cross_prices.each do |cross_price|
            puts "\tcross:: #{cross_price.company.name} :: #{cross_price.original_description} :: #{cross_price.price}"
          end
        end
      end
    end
  end
end

