class Item < ActiveRecord::Base

  attr_accessible :description, :original_description, :vendor_code, :fcenter_code

  has_many :links

  has_many :prices, :through => :links do
    def average_price
      all.average(:price)
    end
  end

  define_index do
    # fields
    indexes description
    indexes original_description, :sortable => true
    indexes vendor_code

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

  def as_flot_data
    js_data = ""
    prices.each do |price|
      js_data << price.as_flot_data << ","
    end
    js_data.chop
  end

  def self.create_from_price(price)
    item = create(
        :original_description => price.original_description,
        :description => price.description,
        :fcenter_code => price.warehouse_code,
        :web_link => price.web_link
    )
    item.add_price(price)
  end
end

