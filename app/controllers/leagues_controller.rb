class LeaguesController < ApplicationController
  def index
    @leagues = League.all
  end

  def user_index
    @leagues = current_user.leagues
    render :index
  end

  def new
    @league = current_user.leagues.build()
  end

  def create
    @league = current_user.leagues.create(league_params)
  end

  def show
    @league = League.find(params[:id])
  end

  def league_params
    params.require(:league).permit(:name, :level)
  end
end
