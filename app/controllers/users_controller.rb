class UsersController < ApplicationController

  skip_before_action :require_login, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)

    if @user.save
      redirect_to @user, notice: 'User profile created'
    else
      flash[:error] = 'Could not create profile'
      render :new
    end
  end

  def show
    @user=User.find(params[:id])
    @teams=@user.teams
  end

  def index
    @users=User.all
  end

  def edit
    @user=User.find(params[:id])
  end

  def update
    @user=User.find(params[:id])
    if @user.update(user_params)
      redirect_to @user, notice: 'User profile was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @user=User.find(params[:id])
    @user.destroy
    redirect_to root_path, notice: 'Profile was successfully deleted.'
  end

  private
    def user_params
      params.require(:user).permit(:username, :password, :password_confirmation, :name, :email)
    end
end
