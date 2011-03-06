# encoding: UTF-8
require_relative "../price_parser_loader.rb"

namespace :app do
  PriceParserLoader.load_parser "oldi"
end