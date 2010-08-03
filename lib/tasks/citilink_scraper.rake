namespace :scrape do

  desc "Scrape CityLink config"
  task :citylink => :environment do
    agent = Mechanize.new
    company = Company.find_by_name("CityLink")
    page = agent.get('http://www.citilink.ru/login/')
    login_form = page.form('mainForm')
    login_form.login = 'xuily@yandex.ru'
    login_form.password = 'poplkl'
    page = agent.submit(login_form, login_form.buttons.first)
    page = page.link_with(:text => "Конфигуратор").click
    config_links = page.search("a.trigger").map {|node| Mechanize::Page::Link.new node, agent, page}
    puts "configuration links found: {#{config_links.size}}"
    config_links.each do |config_link|
      puts "*" * 75
      puts config_link
      puts "*" * 75
      page = config_link.click
      part_links = page.search('td h2')
      part_links.each do |part_link|
        puts "\t" + part_link.text
        if part_link.text =~ /(\d+)\s.+/
          puts "warehouse_code #{$1}"
          price = company.prices.find_by_warehouse_code($1)
          if price
            puts "item :: #{price.original_description} price :: #{price.price}"
            price.cross_prices.each do |cross_price|
              puts "\tcross:: #{cross_price.company.name} :: #{cross_price.original_description} :: #{cross_price.price}"
            end
          end
        end
      end
      STDIN.gets
    end
  end
end

