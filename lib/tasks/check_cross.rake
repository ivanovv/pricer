# encoding: UTF-8
require "ap"

namespace :app do

  desc "check cross code prices"
  task :check_cross => :environment do

    #words = YAML.load_file 'words.yml'
    #word_count = [6,5,4,3,2,1]

    client = ThinkingSphinx::Search.new.client

    Company.find_each do |company|
      ap company
      Price.find_each(:conditions => {:company_id => company.id}) do |price|
        price.cross_prices.each do |cross|
          price_diff = price.price_difference(cross)
          if price_diff.abs > 33
            s = "price.id: #{price.id} cross.id #{cross.id} price.price: #{price.price} cross.price #{cross.price} diff: #{price_diff}"
            puts s
          end
        end
      end
    end
  end
end

