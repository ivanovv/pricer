# encoding: UTF-8
require "ap"

namespace :app do

  desc "Parse next Citilink configurator page"
  task :spider => :environment do
    spider = Spider.first
    spider.parse_next_page
  end

end