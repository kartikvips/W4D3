class SessionsController < ApplicationController
  before_action :logged_in?, only: [:new, :create]

  def new
    render :new
  end

  def create
    user = User.find_by_credentials(session_params[:user_name], session_params[:password])
    login_user!(user)
  end

  def destroy
    if current_user
      current_user.reset_session_token!
      session[:session_token] = ""
      redirect_to cats_url
    end
  end

  private
  def session_params
    params.require(:session).permit(:user_name, :password)
  end











end
