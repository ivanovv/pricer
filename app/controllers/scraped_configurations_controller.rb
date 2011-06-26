class ScrapedConfigurationsController < ApplicationController

  def index
    @scraped_configurations = ScrapedConfiguration.all
  end

  def show
    @scraped_configuration = ScrapedConfiguration.find(params[:id])
  end

  def new
    @scraped_configuration = ScrapedConfiguration.new
  end

  def create
    params[:scraped_configuration] ||= {}
    params[:scraped_configuration][:url] ||= params.try(:[], :url)
    
    @scraped_configuration = ScrapedConfiguration.new(params[:scraped_configuration])
    if @scraped_configuration.save
      redirect_to @scraped_configuration, :notice => "Successfully created scraped configuration."
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
