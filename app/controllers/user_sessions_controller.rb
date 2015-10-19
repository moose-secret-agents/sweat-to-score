class UserSessionsController < ApplicationController

  before_action :require_login, only: [:destroy]

  def new
  end

  def create
    if (@user = login(user_session_params[:username], user_session_params[:password], true))
      redirect_back_or_to(:root, notice: 'Login successful')
    else
      flash.now[:alert] = 'Login failed'
      render :new
    end
  end

  def destroy
    logout
    redirect_to(:root, notice: 'Logged out!')
  end

  private
    def user_session_params
      params.require(:user_session).permit(:username, :password)
    end
end