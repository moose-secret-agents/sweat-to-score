class UsersController < ApplicationController

  skip_before_action :require_login, only: [:new, :create]
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.create(create_params)

    if @user.save
      @coach_user = create_cybercoach_user(@user.username, create_params)

      auto_login(@user, true)
      redirect_to @user, notice: 'User profile created'
    else
      flash[:error] = 'Could not create profile'
      render :new
    end
  end

  def show
    @teams = @user.teams
  end

  def index
    @users = User.all
  end

  def edit
    authorize @user
  end

  def update
    authorize @user
    if @user.update(update_params)

      coach_client.authenticated(@user.username, @user.pw) do
        @user.coach_user.set_client coach_client
        @user.coach_user.update(user_attrs_to_coach(update_params))
      end
      redirect_to @user, notice: 'User profile was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @user.destroy

    coach_client.authenticated(@user.username, @user.pw) do
      @user.coach_user.set_client coach_client
      @user.coach_user.destroy
    end

    redirect_to show_login_path, notice: 'Profile was successfully deleted.'
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def create_params
      p = update_params
      p[:pw] ||= p[:password]
      p
    end

    def update_params
      p = params.require(:user).permit(:username, :password, :password_confirmation, :real_name, :email)
      p[:username] = p[:username].downcase if p[:username]
      p
    end

    def create_cybercoach_user(username, attributes={})
      return nil if coach_client.users.exists? username
      # Create CyCo user unless already exists

      cyco_user = coach_client.users.create(username, user_attrs_to_coach(attributes))

      cyco_user
    end

    def user_attrs_to_coach(attributes)
      cyco_attributes = attributes.slice(:username, :password)

      email = attributes[:email].blank? ? 'generic@email.com' : attributes[:email]
      realname = attributes[:real_name].blank? ? 'Generic Name' : attributes[:real_name]

      cyco_attributes.merge(email: email, realname: realname, publicvisible: 2)
    end
end
