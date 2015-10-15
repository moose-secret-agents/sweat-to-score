class LeaguesController < ApplicationController
  def index
    @leagues = League.all
  end

  def new
    @user = current_user
    @league = @user.leagues.build
  end

  def create
    @user = current_user
    @league = @user.leagues.create(league_params)

    if @league.save
      redirect_to @league, notice: 'League was sucessfully created'
    else
      render :new
    end
  end

  def show
    @league = League.find(params[:id])
  end

  def user_index
    @leagues = current_user.leagues
    render :index
  end

  private
    def league_params
      params.require(:league).permit(:name, :level)
    end
end
