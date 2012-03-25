class ConfigurationLinesController < ApplicationController
  respond_to :html

  def index
    respond_with(@configuration_lines = ConfigurationLine.all)
  end

  def show
    @configuration_line = ConfigurationLine.find params[:id]
  end

  def new
    @configuration_line = ConfigurationLine.new
  end

  def create
    @configuration_line = ConfigurationLine.new(params[:configuration_line])
    if @configuration_line.save
      redirect_to @configuration_line, :notice => "Successfully created configuration line."
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
      redirect_to @configuration_line, :notice  => "Successfully updated configuration line."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @configuration_line = ConfigurationLine.find(params[:id])
    @configuration_line.destroy
    redirect_to configuration_lines_url, :notice => "Successfully destroyed configuration line."
  end
end
