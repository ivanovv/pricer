# encoding: UTF-8
require 'xls_parser'

module PriceParsers

  class JustcomXLSParser < XLSParser

    COMPANY_NAME = "Just-Com"
    DEFAULT_FILE_PATH = '~/tmp/justcom.xls'
    #DEFAULT_ENCODING = 'windows-1251'


    def rows_to_skip
      25
    end

    def initial_row?(row)
      desc = row[indexes[:warehouse]]      
      desc && desc.is_a?(String) && desc.starts_with?('[2716] Процессоры :: Процессоры Intel')
    end

    def should_stop?(row)
      desc = row[indexes[:warehouse]]
      desc.is_a?(String) && desc.starts_with?('[15849] Программное обеспечение')
    end

    def should_parse_row(row)
      if row[warehouse_code_index].to_s =~ /\d+(\.\d)?/
        desc = row[indexes[:description]]
        is_notebook = desc.is_a?(String) && (desc.starts_with?('Нетбук') || desc.starts_with?('Ноутбук') || desc.starts_with?('Планшет'))
        !is_notebook
      else
        false
      end

    end

    def indexes
      {:warehouse => 0, :description => 3, :vendor => nil, :price => 11, :web_link => 0}
    end

    def preprocess_price_attributes(price_attributes)
      price_attributes[:web_link] = price_attributes[:web_link].to_i
      price_attributes[:description].match(/\[([^\]]*)\]/)
      price_attributes[:vendor_code] = $+ if ($+ != "OEM" && $+ != "BOX")
    end

  end
end

