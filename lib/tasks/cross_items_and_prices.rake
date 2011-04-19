# encoding: UTF-8

require "ap"

def without_hash2(existing_links)
  {:without => existing_links.empty? ? {} : {:id => existing_links}}
end

namespace :app do

  desc "cross items and prices"
  task :cross_items => :environment do

    client = ThinkingSphinx::Search.new.client
    time_since_last_update = ENV.include?("update_since") && ENV["update_since"]
    time_since_last_update = time_since_last_update ? eval(time_since_last_update) : 60.minutes.ago

    puts "time_since_last_update: #{time_since_last_update}"
    
    company = ENV["company"] if ENV.include?("company")
    company_conditions = company ? {:conditions => ['id = ?', company]} : {}
    ap company_conditions


    Company.find_each(company_conditions) do |company|
      ap company
      Price.find_each(:conditions => ['company_id = ? and updated_at > ?', company.id, time_since_last_update]) do |price|
        existing_alternatives = price.items.count>0 ? [price.items.first.id] : []
        search_term = price.vendor_code ? price.vendor_code.dup : nil
        desc = price.description.dup
        search_term ||= desc

        items = Item.search(search_term, without_hash2(existing_alternatives))
        if items.size == 0 && search_term != desc
          items = Item.search(desc, without_hash2(existing_alternatives))
        end

        keywords = client.keywords desc, Item.sphinx_index_names.first, true
        keywords = keywords.sort { |x, y| x[:docs] <=> y[:docs] }.first

        if items.empty? && keywords
          if keywords[:docs] > 1 and keywords[:docs] < 12
            items = Item.search(keywords[:tokenised], without_hash2(existing_alternatives))
          end
        end

        if items.size > 0
          case items.size
            when 1
              items.each { |item| item.add_price(price) }
            else
              items2 = Item.search(price.original_description)
              
              if items2 && items2.size == 1
                puts "\t disambiguished with #{items2.first.description}"
                items2.first.add_price(price)
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

