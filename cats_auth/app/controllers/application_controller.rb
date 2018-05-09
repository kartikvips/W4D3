class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user

  def current_user
    User.find_by(session_token: session[:session_token])
  end

  def login_user!(user)

    if user
      user.reset_session_token!
      session[:session_token] = user.session_token
      redirect_to cats_url
    else
      render new_session_url
    end

  end


  private
  def logged_in?
    if !!current_user
      redirect_to cats_url
    end
  end
end
