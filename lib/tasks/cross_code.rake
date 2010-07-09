require "ap"



namespace :app do

  desc "cross code prices"
  task :cross => :environment do

    #words = YAML.load_file 'words.yml'
    #word_count = [6,5,4,3,2,1]

    client = Riddle::Client.new

    Company.find_each do |company|
      ap company
      Price.find_each(:conditions => {:company_id => company.id}) do |price|

        search_term = price.vendor_code.dup if price.vendor_code
        desc = price.description.dup

        search_term ||= desc

        cross_prices = Price.search search_term, :without => {:company_id => company.id}
        cross_prices = Price.search desc, :without => {:company_id => company.id} if cross_prices.size == 0 && search_term != desc

        keywords = client.keywords desc, "price_core", true
        keywords = keywords.sort {|x, y| x[:docs] <=> y[:docs]}.first 3

        if cross_prices.empty? && keywords && keywords[0]
          if keywords[0][:docs] > 1 and  keywords[0][:docs] < 12
            cross_prices = Price.search keywords[0][:tokenised], :without => {:company_id => company.id}
          end
        end

        if cross_prices.size > 0
          comp_count = Hash.new(0)
          cross_prices.map(&:company_id).each {|company_id| comp_count[company_id] += 1 }
          comp_count.each do |company_id, found_results_count|
            puts "Comp:#{company.name} multiple variants (#{found_results_count}) found for ::: #{search_term} :: in company id #{company_id}  " if found_results_count > 1
            case found_results_count
            when 0
              if keywords[0][:docs] > 1 and  keywords[0][:docs] < 12
                cross_prices = Price.search keywords[0][:tokenised], :with => {:company_id => company_id}
                price.cross_prices << cross_prices[0] if cross_prices.size == 1
                if cross_prices.size > 1
                  cross_prices = Price.search keywords[0][:tokenised] + "oem" , :with => {:company_id => company_id}
                  price.cross_prices << cross_prices[0] if cross_prices.size == 1
                end
              end
            when 1
            cross_prices.select { |cross_price| cross_price.company_id == company_id }.each { |cross_price| price.cross_prices << cross_price } if found_results_count == 1
            else
              cross_price2 = []
              cross_price2[0] = Price.search search_term + " oem | bulk ", :with => {:company_id => company_id}, :match_mode => :boolean
              cross_price2[1] = Price.search desc, :with => {:company_id => company_id}
              cross_price2[2] = Price.search keywords[0][:tokenised] + " oem | bulk" , :with => {:company_id => company_id}, :match_mode => :boolean if keywords[0][:docs] > 1 and  keywords[0][:docs] < 12
              #puts "cross_price2_2.size #{cross_price2_2.size} cross_price2_1.size #{cross_price2_1.size} cross_price2_3.size #{cross_price2_3.size}"

              cross_price2 = cross_price2.compact.reject {|a| a.empty?}
              if cross_price2.size == 2
                cross_price2 = cross_price2[0] & cross_price2[1] if cross_price2.size == 2
              else
                cross_price2 = cross_price2[0]
              end
              ap cross_price2

              if cross_price2 && cross_price2.size == 1
                puts "\t disambiguished with #{cross_price2[0].description}"
                price.cross_prices << cross_price2[0]
              end
            end
          end
        end
      end
    end
  end
end

