# encoding: UTF-8

require "ap"

def without_hash(company_id, existing_alternatives)
  { :without => {:company_id => company_id}.merge(existing_alternatives.empty? ? {} : {:id => existing_alternatives}) }
end

namespace :app do

  desc "cross code prices"
  task :cross => :environment do

    client = ThinkingSphinx::Search.new.client
    force = ENV.include?("force")
    time_since_last_update = force ? 10.year.ago : 60.minutes.ago

    Company.find_each do |company|
      ap company
      Price.find_each(:conditions => ['company_id = ? and updated_at > ?', company.id, time_since_last_update ]) do |price|
        existing_alternatives = price.cross_price_ids

        search_term = price.vendor_code ? price.vendor_code.dup : nil
        desc = price.description.dup

        search_term ||= desc

        cross_prices = Price.search search_term, without_hash(company.id, existing_alternatives)
        if cross_prices.size == 0 && search_term != desc
          cross_prices = Price.search desc, without_hash(company.id, existing_alternatives)
        end

        keywords = client.keywords desc, Price.sphinx_index_names.first, true
        keywords = keywords.sort {|x, y| x[:docs] <=> y[:docs]}.first

        if cross_prices.empty? && keywords
          if keywords[:docs] > 1 and keywords[:docs] < 12
            cross_prices = Price.search  keywords[:tokenised], without_hash(company.id, existing_alternatives)
          end
        end

        if cross_prices.size > 0

          comp_count = Hash.new(0)
          cross_prices.map(&:company_id).each { |company_id| comp_count[company_id] += 1 }

          comp_count.each do |company_id, found_results_count|
            puts "Comp:#{company.name} multiple variants (#{found_results_count}) found for ::: #{search_term} :: in company id #{company_id}  " if found_results_count > 1
            case found_results_count
            when 0
              if keywords[:docs] > 1 and keywords[:docs] < 12
                cross_prices = Price.search  keywords[:tokenised], :with => {:company_id => company_id}
                price.add_alternative(cross_prices[0]) if cross_prices.size == 1
              end

            when 1
              cross_prices.select { |cross_price| cross_price.company_id == company_id }.
                each { |cross_price| price.add_alternative(cross_price) }
            else

              cross_price2 = []

              cross_price2[0] = Price.search(search_term + " oem | bulk", :with => {:company_id => company_id}, :match_mode => :boolean)

              cross_price2[1] = Price.search(desc, :with => {:company_id => company_id})
              if keywords[:docs] > 1 and  keywords[:docs] < 12
                cross_price2[2] = Price.search(keywords[:tokenised] + " oem | bulk" , :with => {:company_id => company_id}, :match_mode => :boolean)
              end

              cross_price2 = cross_price2.compact.reject {|a| a.empty?}
              if cross_price2.size == 2
                cross_price2 = cross_price2[0] & cross_price2[1]
              else
                cross_price2 = cross_price2[0]
              end

              if cross_price2 && cross_price2.size == 1
                puts "\t disambiguished with #{cross_price2[0].description}"
                price.add_alternative(cross_price2[0])
              end
            end
          end
        end
      end
    end
  end
end

