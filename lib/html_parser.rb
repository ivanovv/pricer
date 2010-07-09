require 'nokogiri'

class HTMLParser < PriceParser

  def self.parse_price(path)
    html = File.open(path) { |f| Nokogiri::HTML(f, nil, 'windows-1251') }
    company = find_company    

    html.css("tr").each do |row|
      next if should_skip_row(row)
      original_desc = row.at_css("a") ? row.at_css("a").text : row.children[1].text
      desc = normalize_description(original_desc)
      warehouse_code = row.children[0].text
      Price.create(
      :company_id => company.id,
      :warehouse_code => warehouse_code,
      :description => desc,
      :original_description => original_desc
      #:vendor_code => indexes[:vendor] ? row[ indexes[:vendor] ] : nil
      )
    end
  end
end

class FcenterPrice < Nokogiri::XML::SAX::Document

CATEGORIES= [
  'Процессоры',
  'Охлаждающие устройства',
  'Материнские платы',
  'Модули памяти',
  'Модули памяти для ноутбуков',
  'Накопители на жестких дисках',
  'Контейнеры для жестких дисков, CD-ROM',
  'Дисководы',
  'Видеокарты',
  'Приводы CD, DVD, BD',
  'Аудиокарты',
  'Контроллеры',
  'ТВ-тюнеры, устройства видеозахвата',
  'Устройства для ноутбуков и КПК',
  'Корпуса',
  'Блоки питания'
]
  def start_document
    @in_good_category = true
  end

  def start_element(element, attributes)
    case element
    when 'tr' then
       @is_category_row = attributes[0] == 'class' && attributes[1] == 'e'
       @td_index = 0
       @row_data = {}
    when 'td'
      @in_td = true
      @td_index += 1
    end
  end

  def characters(data)
    unless @in_good_category
      return unless @is_category_row
    end
    @row_data[@td_index] = data if @in_td and @td_index < 3
  end

  def end_element(element)
    case element
    when 'td' then @in_td = false
    when 'tr'
      case @td_index
      when 2 then @in_good_category = CATEGORIES.include? @row_data[2]
      when 13 then ap @row_data if @in_good_category
      end
    end
  end
end

parser = Nokogiri::HTML::SAX::Parser.new( FcenterPrice.new, 'windows-1251')
parser.parse_file("/home/victor/Documents/price.html", 'windows-1251')

