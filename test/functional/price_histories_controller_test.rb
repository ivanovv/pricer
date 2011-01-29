require 'test_helper'

class PriceHistoriesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => PriceHistory.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    PriceHistory.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    PriceHistory.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to price_history_url(assigns(:price_history))
  end

  def test_edit
    get :edit, :id => PriceHistory.first
    assert_template 'edit'
  end

  def test_update_invalid
    PriceHistory.any_instance.stubs(:valid?).returns(false)
    put :update, :id => PriceHistory.first
    assert_template 'edit'
  end

  def test_update_valid
    PriceHistory.any_instance.stubs(:valid?).returns(true)
    put :update, :id => PriceHistory.first
    assert_redirected_to price_history_url(assigns(:price_history))
  end

  def test_destroy
    price_history = PriceHistory.first
    delete :destroy, :id => price_history
    assert_redirected_to price_histories_url
    assert !PriceHistory.exists?(price_history.id)
  end
end
