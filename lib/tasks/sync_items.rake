# encoding: UTF-8
require_relative "../fcenter.rb"
require 'differ'

def numeric?(object)
  true if Float(object) rescue false
end

namespace :app do

  desc "sync items with F-Center price"
  task :sync_items => :environment do
    client = Riddle::Client.new
    Differ.format = :color


    last_update_to_items = Item.order('created_at desc').first.created_at
    conditions = ['company_id = ? and created_at > ?', Company.find_by_name(FCenterParser::COMPANY_NAME).id, last_update_to_items]
    conditions = ['company_id = ?', Company.find_by_name(FCenterParser::COMPANY_NAME).id]
    Price.find_each(:conditions => conditions) do |price|
      item = Item.find_by_fcenter_code(price.warehouse_code)
      item ||= Item.find_by_original_description(price.original_description)
      item ||= Item.search(Riddle.escape(price.original_description))
      if item == nil || (item.respond_to?(:empty?) && item.empty?)
        puts "price:: #{price} code:: #{price.warehouse_code}"
        puts "Trying to find proper price with ::#{price.most_unlikely_search}::"
        items = Item.search(price.most_unlikely_search)
        puts "#{items.first} total found: #{items.size}"
        if items.size > 1
          puts
          puts "Trying to find proper price with ::#{price.most_unlikely_search(2)}::"
          items2 = Item.search(price.most_unlikely_search(2))
          items = items2 if items2.size > 0
        end
        puts "total found: #{items.size}"
        items.each do |item|
          puts "item :: #{item}"
        end
        puts

        index = 0
        index = STDIN.gets.chomp.downcase.to_i if items.size > 1

        if items.size > 0
          diff = Differ.diff_by_char(items[index].to_s, price.to_s)
          puts "diff :: #{diff}"

          user_decision = STDIN.gets.chomp.downcase

          if user_decision == "y"
            item = items[index]
            item.fcenter_code = price.warehouse_code
            if item.original_description != price.original_description
              item.original_description = price.original_description
            end
            item.save
          end
        end
        
        puts "=" * 70

      end
      #Item.create_from_price(price) unless item
    end
  end
end
