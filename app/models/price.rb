# encoding: UTF-8
class Price < ActiveRecord::Base

  belongs_to :company

  has_and_belongs_to_many :cross_prices,
                          :class_name => "Price",
                          :join_table => "cross_prices",
                          :foreign_key => "price_id",
                          :association_foreign_key => "cross_price_id"

  has_many :price_histories
  has_many :links
  has_many :items, :through => :links


  define_index do
    # fields
    indexes description
    indexes original_description, :sortable => true
    indexes vendor_code

    # attributes
    has company_id, warehouse_code, id
  end

  def self.find_alternatives(company_id, warehouse_code)
    price = Price.find_by_company_id_and_warehouse_code(company_id, warehouse_code)
    if price
      price.cross_prices
    end
  end

  def price_difference(alternative)
    (alternative.price.to_f - price.to_f) / price.to_f * 100
  end

  def add_alternative(alternative)
    if !cross_prices.include?(alternative) && price_difference(alternative).abs < 33
      self.cross_prices << alternative
      Rails.logger.debug("Added alternative")
    end
  end

  def set_reference_item(new_item)
    if items.count == 0 || items.first != new_item
      self.items << new_item
      Rails.logger.debug("Added to items")
    end
  end

  def as_json(options = {})
    #super(options.merge(:only => [ :id, :company_id, :original_description, :vendor_code, :created_at, :name ], :include => :company ))
    super((options||{}).merge(:include => :company, :methods => [:linked, :company_name, :price_value]))
  end

  def to_s
    original_description
  end

  def price_value
    price_value = if price_histories && price_histories.last
                     price_histories.last.value
                   end
    price_value || price
  end

  def linked
    links.size != 0 ? "Да" : "Нет"
  end

  def company_name
    company.name
  end

  def product_web_link
    company.base_product_link + web_link if web_link
  end

  def as_flot_data
    js_data = ""
    last_history_record = nil
    price_histories.each do |history_record|
      js_data << history_record.as_flot_data << ","
      last_history_record = history_record
    end
    label = "#{original_description} (#{company.name})"
    js_data << "[#{Time.now.utc.to_i * 1000}, #{last_history_record.value}]," if last_history_record
    "{\"data\": [#{js_data.chop}], \"label\": #{label.to_json}, \"color\":#{company_id}, \"price_id\":#{id}}"
  end

  def most_likely_search
    pretty_keywords(4).join(" ")
  end

  def most_likely_search_tokenised
    i = 1
    keywords = pretty_keywords(4).map { |keyword| i += 1; {:id => i, :name => keyword} }
    keywords.to_json
  end

  def most_unlikely_search_tokenised
    i = 1
    keywords = most_unlikely_search(10).map { |keyword| i += 1; {:id => i, :name => keyword} }
    keywords.to_json
  end

  def most_unlikely_search(n = 1)
    pretty_keywords(100).reverse.first n
  end

  def sphinx_keywords(n = 3)
    client = ThinkingSphinx::Search.new.client
    keywords = client.keywords description, Item.sphinx_index_names.first, true
    keywords = keywords.sort { |x, y| y[:docs] <=> x[:docs] }
    keywords.first n
  end

  def sphinx_keywords_for_javascript(n = 3)
    {:likely => pretty_keywords(n), :unlikely => most_unlikely_search(n)}.to_json
  end

  def pretty_keywords(n = 3)
    sphinx_keywords(n).map do |k|
      pretty_key = k[:tokenised]
      pretty_key = pretty_key.force_encoding("UTF-8") if "".respond_to?(:force_encoding)
      pretty_key
    end
  end

  def update_price_history(price_value)
    last_price_history = price_histories.order(:created_at).last
    if !last_price_history ||
        (last_price_history.value != price_value && last_price_history.created_at < 10.minutes.ago) then
      price_histories.create(:value => price_value)
      true
    else
      false
    end
  end

  def update_original_description(original_desc)
    if original_description != original_desc
      old_original_description = original_description
      self.description = PriceDescriptionNormalizer.normalize_description(original_desc)
      self.original_description = original_desc
      save
      Rails.logger.debug("update original description:: old #{old_original_description} new #{original_desc}")
      true
    else
      false
    end
  end

end

