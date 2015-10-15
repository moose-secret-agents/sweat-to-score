class UsersController < ApplicationController
  def show
    @user=User.find(params[:id])
    @teams=@user.teams
  end

  def index
    @users=User.all
  end

  def edit
  end
end
