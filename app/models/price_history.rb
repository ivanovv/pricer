class PriceHistory < ActiveRecord::Base
    attr_accessible :value
    belongs_to :price

  def created_at_as_flot_date
    created_at.utc.to_i * 1000
  end

  def as_json
    super( {:only => ["value", "created_at"]} )
  end

  def as_flot_data
    [created_at_as_flot_date, value]
  end

  def to_s
    "#{created_at} #{value}"
  end
end

