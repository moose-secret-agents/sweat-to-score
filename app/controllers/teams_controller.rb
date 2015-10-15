class TeamsController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @teams = @user.teams
  end

  def show
    @team = Team.find(params[:id])
  end
end
