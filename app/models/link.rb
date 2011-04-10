class Link < ActiveRecord::Base
  attr_accessible :item_id, :price_id, :item, :price, :human, :score, :other_prices

  after_save :update_other_parties

  attr_accessor :other_prices

  belongs_to :price
  belongs_to :item



  def update_other_parties
    self.price.many_items_found=false
    self.price.save
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
