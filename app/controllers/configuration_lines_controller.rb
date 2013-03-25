# encoding: UTF-8
class ConfigurationLinesController < ApplicationController
  respond_to :html
  before_filter :load_configuration

  def index
    respond_with(@configuration_lines = @configuration.configuration_lines)
  end

  def show
    @configuration_line = ConfigurationLine.find params[:id]
  end

  def new
    @configuration_line = @configuration.configuration_lines.build
  end

  def create
    @configuration_line = ConfigurationLine.new(params[:configuration_line])
    if @configuration_line.save
      redirect_to [@configuration, @configuration_line], :notice => 'Successfully created configuration line.'
    else
      render :action => 'new'
    end
  end

  def edit
    @configuration_line = ConfigurationLine.find(params[:id])
  end

  def update
    @configuration_line = ConfigurationLine.find(params[:id])
    if @configuration_line.update_attributes(params[:configuration_line])
      redirect_to [@configuration, @configuration_line], :notice  => 'Successfully updated configuration line.'
    else
      render :action => 'edit'
    end
  end

  def destroy
    @configuration_line = ConfigurationLine.find(params[:id])
    @configuration_line.destroy
    redirect_to @configuration, :notice => 'Successfully destroyed configuration line.'
  end

  private

  def load_configuration
    @configuration = ScrapedConfiguration.find params[:scraped_configuration_id]
  end
end
