class PriceHistory < ActiveRecord::Base
    attr_accessible :price
    belongs_to :price
end

