class ApplicationController < ActionController::Base
  protect_from_forgery
  helper :layout
  helper_method :current_user
  helper_method :user_signed_in?
  helper_method :correct_user?

  private
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
    return if Rails.env? "development"
    if !current_user || current_user.uid.to_s != "5754774"
      redirect_to root_url, :alert => 'You need to sign in for access to this page.'
    end
  end

end
