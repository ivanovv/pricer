# encoding: UTF-8

require "ap"

def without_hash2(existing_links)
  { :without => existing_links.empty? ? {} : {:id => existing_links} }
end

namespace :app do

  desc "cross items and prices"
  task :cross_items => :environment do

    client = Riddle::Client.new
    force = ENV.include?("force")
    time_since_last_update = force ? 10.year.ago : 10.minutes.ago

    company = ENV["company"] if ENV.include?("company")
    company_conditions = company ? {:conditions => ['id = ?', company]} : {}
    ap company_conditions


    Company.find_each(company_conditions) do |company|
      ap company
      Price.find_each(:conditions => ['company_id = ? and updated_at > ?', company.id, time_since_last_update ]) do |price|
        existing_alternatives = price.items.count>0 ? [price.items.first.id] : []
        search_term = price.vendor_code ? price.vendor_code.dup : nil
        desc = price.description.dup
        search_term ||= desc

        items = Item.search(Riddle.escape(search_term), without_hash2(existing_alternatives))
        if items.size == 0 && search_term != desc
          items = Item.search(Riddle.escape(desc), without_hash2(existing_alternatives))
        end

        keywords = client.keywords desc, "price_core", true
        keywords = keywords.sort {|x, y| x[:docs] <=> y[:docs]}.first

        if items.empty? && keywords
          if keywords[:docs] > 1 and keywords[:docs] < 12
            items = Item.search(Riddle.escape(keywords[:tokenised]), without_hash2(existing_alternatives))
          end
        end

        if items.size > 0
          case items.size
          when 1
            items.each { |item| item.add_price(price)}
          else
            items2 = []
            items2[0] = Item.search(Riddle.escape(price.original_description))
            items2[1] = Item.search(Riddle.escape(search_term) + " oem | bulk", :match_mode => :boolean)
            if keywords[:docs] > 1 and  keywords[:docs] < 12
              items2[2] = Item.search( Riddle.escape(keywords[:tokenised]) + " oem | bulk" , :with => {}, :match_mode => :boolean)
            end
            items2 = items2.compact.reject {|a| a.empty?}
            if items2.size == 2
              items2 = items2[0] & items2[1]
            else
              items2 = items2[0]
            end
            ap items2
            if items2 && items2.size == 1
              puts "\t disambiguished with #{items2[0].description}"
              items2[0].add_price(price)
            else
              price.many_items_found = true
              price.save
            end
          end
        end
      end
    end
  end
end

