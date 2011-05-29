# encoding: UTF-8
#require_relative "../price_parser_loader.rb"
require File.join(File.dirname(__FILE__), '../price_parser_loader.rb')



namespace :app do
  PriceParserLoader.load_parser "justcom"
end