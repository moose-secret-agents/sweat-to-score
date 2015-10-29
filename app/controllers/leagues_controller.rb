class LeaguesController < ApplicationController
  before_action :set_user, only: [:new, :create]

  def index
    @leagues = League.all
  end

  def new
    @league = @user.leagues.build
  end

  def create
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

  def edit
    SchedulerDoubleRR.new.schedule_season(League.find(params[:id]))
  end

  private
    def league_params
      params.require(:league).permit(:name, :level)
    end

    def set_user
      @user = current_user
    end
end
