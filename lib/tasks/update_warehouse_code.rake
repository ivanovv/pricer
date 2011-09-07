# encoding: UTF-8

namespace :app do

  desc "Check all prices that are linked to the item and use vendor code, if it is the same for all of them"
  task :update_vendor_code => :environment do
    Item.find_each do |item|
      vendor_codes = []
      item.prices.each do |price|
        vendor_codes << price.vendor_code.upcase if price.vendor_code
      end

      if vendor_codes.length > 2 && vendor_codes.uniq.length == 1 && item.vendor_code.blank?
        item.vendor_code = vendor_codes.uniq.first
        item.save
      end
    end
  end
end
