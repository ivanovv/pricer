# encoding: UTF-8
#require_relative "../fcenter.rb"
#require File.join(File.dirname(__FILE__), '../price_parsers/fcenter.rb')

namespace :app do

  desc "sync items with F-Center price"
  task :sync_items => :environment do
    company = Company.find_by_name(PriceParsers::FCenterParser.company_name)

    last_update_to_items = Item.order('created_at desc').first.created_at
    conditions = ['company_id = ? and created_at > ?', company.id, last_update_to_items]
    conditions = ['company_id = ?', company.id]
    prices = []
    Price.find_each(:conditions => conditions) do |price|
      item = Item.find_by_fcenter_code(price.warehouse_code)
      unless item
        prices << price
        Item.create_from_price(price)
        puts "sync_items:: <#{price}> added to items"
      end
    end
    NotificationMailer.sync_stats(prices).deliver
    NotificationMailer.parse_stats(ParsingResult.today_stats).deliver
  end
end
