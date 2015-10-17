class UsersController < ApplicationController
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

  private
    def user_params
      params.require(:user).permit(:name, :password, :email)
    end
end
