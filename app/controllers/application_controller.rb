class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  # Redirect the user to the login page if not loggedin
  def require_login
      if !logged_in?
          redirect_to login_path(@user)
      end
  end
  
  def current_user
    #which says return the @user variable if it’s not nil, or if it is nil, return User.find(session[:user_id_]), and set @user equal to that user.
    @user ||= User.where("id=?",session[:user_id]).first
  end
   
   
  def logged_in?
    !current_user.nil? && !current_user.id.nil?
  end

  helper_method :current_user
  helper_method :logged_in?
   
end
   



