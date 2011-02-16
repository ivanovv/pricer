class Link < ActiveRecord::Base
  attr_accessible :item_id, :price_id, :human, :score

  belongs_to :price
  belongs_to :item
  
end
