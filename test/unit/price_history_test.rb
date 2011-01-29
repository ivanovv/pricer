require 'test_helper'

class PriceHistoryTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert PriceHistory.new.valid?
  end
end
