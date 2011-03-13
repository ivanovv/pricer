class Item < ActiveRecord::Base

  attr_accessible :description, :original_description, :vendor_code

  has_many :links
  
  has_many :prices, :through => :links do
    def average_price
      all.average(:price)
    end
  end

  define_index do
    # fields
    indexes description
    indexes original_description
    indexes vendor_code

    #set_property :enable_star => true
    #set_property :min_prefix_len => 3
    #set_property :min_infix_len => 3

    # attributes
    has id
  end

  def to_s
    original_description
  end

  def add_price(price, human = false, score = 0)
    if !prices.include?(price)
      self.links.build(:price_id => price.id, :human => human, :score => score)
      save
      Rails.logger.debug("Added price #{price} to item #{self}")
    end
  end

  def get_history_data_for_javascript
    js_data = ""
    prices.each do |price|
      js_data << price.get_history_data_for_javascript << ","
    end
    js_data.chop
  end
end

