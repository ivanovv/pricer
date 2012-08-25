require 'uri'
require 'cgi'

class ApplicationController < ActionController::Base
  protect_from_forgery
  helper :layout
  helper_method :current_user
  helper_method :user_signed_in?
  helper_method :correct_user?

  before_filter :check_yandex_referrer
  before_filter :enable_mini_profiler

  private

  def enable_mini_profiler
    if Rails.env.development? || (current_user && current_user.uid.to_s == "5754774")
      Rack::MiniProfiler.authorize_request
    end
  end

  def current_user
    begin
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    rescue
      nil
    end
  end

  def user_signed_in?
    return true if current_user
  end

  def correct_user?
    @user = User.find(params[:id])
    unless current_user == @user
      redirect_to root_url, :alert => "Access denied."
    end
  end

  def authenticate_user!
    return if Rails.env.development?
    if !current_user || current_user.uid.to_s != "5754774"
      redirect_to root_url, :alert => 'You need to sign in for access to this page.'
    end
  end

  def get_company
    @company = begin
      Company.find params[:company_id] rescue nil
    end
  end

  def check_yandex_referrer
    begin
      referer = request.headers["HTTP_REFERER"]
      return if referer.blank?

      se = {
          :google => {:regexp => /^http:\/\/(www\.)?google.*/, :query_string => 'q'},
          :yandex => {:regexp => /^http:\/\/(www\.)?yandex.*/, :query_string => 'text'}
      }
      uri = URI.parse referer
      if (search_engine = se.detect { |v| referer.match(v[1][:regexp]) })
        se2 = search_engine[0].to_s
        keywords = CGI.parse(uri.query)[search_engine[1][:query_string]][0]
        if request.fullpath.match(/\/prices\?page\=/) && !request.url.to_s.match(/\/searches/)
          redirect_to({:controller => :searches, :action => :index, :q => keywords})
        end
      end
    end
  rescue
  end

end
