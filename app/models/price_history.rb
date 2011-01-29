class PriceHistory < ActiveRecord::Base
    attr_accessible :value
    belongs_to :price
end

