class UserSessionsController < ApplicationController

  before_action :require_login, only: [:destroy]

  def new
  end

  def create
    username = user_session_params[:username]
    password = user_session_params[:password]

    # Check Logging credentials against CyCo and local DB
    if coach_client.users.authenticated?(username, password) && (@user = login(username, password, true))
      redirect_back_or_to(:root, notice: 'Login successful')
    else
      fail_login
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

    def fail_login
      flash.now[:alert] = 'Login failed'
      render :new
    end
end