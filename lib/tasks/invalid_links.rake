#encoding: UTF-8

namespace :app do

  desc "remove doubles from items"
  task :clean_items => :environment do
    company = Company.find_by_name(PriceParsers::FCenterParser.company_name)

    links = Link.with_multiple_items.all
    items = links.map {|l| l.item ? l.item.id : 0}
    conditions = ['id in (?)', items.uniq]

    Item.find_each(:conditions => conditions) do |item|
      prices = item.prices.all || []
      prices.each do |p|
        if p.company_id == company.id && p.warehouse_code != item.fcenter_code
          puts "clean_items:: <#{p}> will be removed from #{item}"
          #item.prices.delete(p)
        end
      end
    end
  end
end