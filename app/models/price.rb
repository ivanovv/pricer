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
    indexes original_description
    indexes vendor_code

    #set_property :enable_star => true
    #set_property :min_prefix_len => 3
    #set_property :min_infix_len => 3

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
    if item || item != new_item
      self.item = new_item
      Rails.logger.debug("Added to items")
    end
  end

  def to_s
    original_description
  end

end

