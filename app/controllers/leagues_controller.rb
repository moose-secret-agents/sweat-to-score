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
	@teams = @league.teams.sort_by(&:rank_in_league)

    matches=Hash.new{|h, k| h[k] = []}
    @league.matches.each{|match| matches[match.starts_at]<<match}

    @matches = matches.values
  end

  def update
    @league = League.find(params[:id])
    if params[:status]!=nil
      if params[:status]==League.statuses[:active].to_s&&League.statuses[@league.status]==League.statuses[:inactive]
        @league.start
        redirect_to @league, notice: 'League started'
      elsif params[:status]==League.statuses[:inactive].to_s&&League.statuses[@league.status]==League.statuses[:active]
        @league.end
        redirect_to @league, notice: 'League ended'
      else
        flash[:error] = "League is already {@league.status}"
        #redirect_to @league, notice: 'League is already #{@league.status}'
        redirect_to @league
      end
    end


  end

  def user_index
    @leagues = current_user.leagues
    render :index
  end

  def edit

  end

  private
    def league_params
      params.require(:league).permit(:name, :level)
    end

    def set_user
      @user = current_user
    end
end
