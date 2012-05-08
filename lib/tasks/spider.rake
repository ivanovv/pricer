# encoding: UTF-8
require "ap"

namespace :app do

  desc "Parse next Citilink configurator page"
  task :spider => :environment do
    company_name = ENV["company"] if ENV.include?("company")
    company = Company.find_by_name company_name
    spider = Spider.find_by_company_id company.id
    spider.parse_next_page if spider.enabled?
  end

end