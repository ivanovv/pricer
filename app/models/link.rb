class Link < ActiveRecord::Base
  attr_accessible :item_id, :price_id, :item, :price, :human, :score, :other_prices

  after_save :update_other_parties

  attr_accessor :other_prices

  belongs_to :price
  belongs_to :item

  validates :price_id, :presence => true, :on => :create
  validates :item_id, :presence => true, :on => :create

  def as_json(options = {})
    super(options.merge(:only => [ :id, :item_id, :price_id, :created_at]))
  end

  def update_other_parties
    self.price.many_items_found=false
    self.price.save
  end

  def self.create_many_links(price_ids, item_id)
    price_ids.split(",").each do |price_id|
      Link.create(:price_id => price_id, :item_id => item_id, :human => true, :score => 10)
    end
  end


  def link_crossed_prices
    self.price.cross_prices.each do |cross_price|
      if !self.class.exists?(:price_id => cross_price.id, item_id => self.item_id)
        self.class.create(:price_id => cross_price.id,
                    :item_id => self.item_id,
                    :human => self.human?,
                    :score => self.score - 1)
      end

    end
  end
  
end
