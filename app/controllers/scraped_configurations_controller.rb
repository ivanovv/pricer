# encoding: UTF-8
class ScrapedConfigurationsController < ApplicationController

  respond_to :html

  before_filter :get_company


  def index
    if !@company
      @scraped_configurations = ScrapedConfiguration.order(:created_at).page(params[:page])
    else
      @scraped_configurations = @company.scraped_configurations.order(:created_at).page(params[:page])
    end
    respond_with(@scraped_configurations)
  end

  def show
    @scraped_configuration = ScrapedConfiguration.find(params[:id])
  end

  def new
    @scraped_configuration = ScrapedConfiguration.new
  end

  def create
    url = params.try(:[], :url) || params[:scraped_configuration][:url]

    @scraped_configuration, valid = ScrapedConfiguration.create_from_config_url(url)
    if valid
      redirect_to @scraped_configuration, :notice => "Конфигурация сохранена."
    else
      render :action => 'new'
    end
  end

  def edit
    @scraped_configuration = ScrapedConfiguration.find(params[:id])
  end

  def update
    @scraped_configuration = ScrapedConfiguration.find(params[:id])
    if @scraped_configuration.update_attributes(params[:scraped_configuration])
      redirect_to @scraped_configuration, :notice  => "Successfully updated scraped configuration."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @scraped_configuration = ScrapedConfiguration.find(params[:id])
    @scraped_configuration.destroy
    redirect_to scraped_configurations_url, :notice => "Successfully destroyed scraped configuration."
  end
end

