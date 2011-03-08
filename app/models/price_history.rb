class PriceHistory < ActiveRecord::Base
    attr_accessible :value
    belongs_to :price

  def js_date
    created_at.utc.to_i * 1000
  end
end

