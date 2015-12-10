class UserSessionsController < ApplicationController

  before_action :require_login, only: [:destroy]

  def new
  end

  def create
    username = user_session_params[:username]
    password = user_session_params[:password]

    session[:password] = password

    # Check Logging credentials against CyCo and local DB
    if coach_client.users.authenticated?(username, password)
      # create local account if not exists
      User.create!(username: username, password: password, password_confirmation: password) unless User.find_by(username: username)
      @user = login(username, password, true)
      # Subscribe to running and cycling
      coach_client.authenticated(username, password) do

        @coach_user = @user.coach_user
        @coach_user.set_client(coach_client)
        @coach_user.subscribe_to :cycling
        @coach_user.subscribe_to :running
      end
      redirect_back_or_to(:root, notice: 'Login successful')
    else
      fail_login
    end
  end

  def destroy
    logout
    session[:password] = nil
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