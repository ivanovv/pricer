# encoding: UTF-8
require 'xls_parser'

module PriceParsers

  class JustcomXLSParser < XLSParser

    belongs_to_company 'Just-Com'

    DEFAULT_FILE_PATH = '~/tmp/justcom.xls'
    #DEFAULT_ENCODING = 'windows-1251'
    ITEMS_TO_SKIP = ['Нетбук', 'Планшет', 'Ноутбук', 'Моноблок', 'Неттоп', 'Системный блок']

    def rows_to_skip
      25
    end

    def initial_row?
      desc = warehouse_code
      desc && desc.is_a?(String) && desc.starts_with?('[2716] Процессоры :: Процессоры Intel')
    end

    def should_stop?
      desc = warehouse_code
      desc.is_a?(String) && desc.starts_with?('[15849] Программное обеспечение')
    end

    def should_parse_row
      if warehouse_code.to_s =~ /\d+(\.\d)?/
        is_notebook = description.is_a?(String) &&
            (ITEMS_TO_SKIP.any? {|item_title| description.starts_with? item_title})
        !is_notebook
      else
        false
      end
    end

    def indexes
      {:warehouse => 0, :description => 3, :vendor => nil, :price => 16, :web_link => 0}
    end

    def create_price_attributes
      price_attributes = super
      price_attributes[:web_link] = price_attributes[:web_link].to_i
      price_attributes[:original_description].match(/\[([^\]]*)\]/)
      price_attributes[:vendor_code] = $+ if ($+ != 'OEM' && $+ != 'BOX')
      price_attributes
    end
  end
end


