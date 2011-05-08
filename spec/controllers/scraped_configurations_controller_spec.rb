require File.dirname(__FILE__) + '/../spec_helper'

describe ScrapedConfigurationsController do
  fixtures :all
  render_views

  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end

  it "show action should render show template" do
    get :show, :id => ScrapedConfiguration.first
    response.should render_template(:show)
  end

  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end

  it "create action should render new template when model is invalid" do
    ScrapedConfiguration.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should render_template(:new)
  end

  it "create action should redirect when model is valid" do
    ScrapedConfiguration.any_instance.stubs(:valid?).returns(true)
    post :create
    response.should redirect_to(scraped_configuration_url(assigns[:scraped_configuration]))
  end

  it "edit action should render edit template" do
    get :edit, :id => ScrapedConfiguration.first
    response.should render_template(:edit)
  end

  it "update action should render edit template when model is invalid" do
    ScrapedConfiguration.any_instance.stubs(:valid?).returns(false)
    put :update, :id => ScrapedConfiguration.first
    response.should render_template(:edit)
  end

  it "update action should redirect when model is valid" do
    ScrapedConfiguration.any_instance.stubs(:valid?).returns(true)
    put :update, :id => ScrapedConfiguration.first
    response.should redirect_to(scraped_configuration_url(assigns[:scraped_configuration]))
  end

  it "destroy action should destroy model and redirect to index action" do
    scraped_configuration = ScrapedConfiguration.first
    delete :destroy, :id => scraped_configuration
    response.should redirect_to(scraped_configurations_url)
    ScrapedConfiguration.exists?(scraped_configuration.id).should be_false
  end
end
