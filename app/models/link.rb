class Link < ActiveRecord::Base
  attr_accessible :item_id, :price_id, :human, :score

  belongs_to :prices
  belongs_to :item
  
end
