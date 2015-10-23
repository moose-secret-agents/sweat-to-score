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
    @rank_teams = rank_teams
  end

  def user_index
    @leagues = current_user.leagues
    render :index
  end

  
  private
    def league_params
      params.require(:league).permit(:name, :level)
    end

    def set_user
      @user = current_user
    end

    def rank_teams
      sorted_teams = @league.teams.sort_by {|team| team.points}

      points_array=[]
      sorted_teams.each do |team|
        points_array.append(team.points)
      end

      sorted_points = points_array.sort.uniq.reverse
      array_mapping = points_array.map{|i| sorted_points.index(i) + 1}.reverse

      [sorted_teams, array_mapping]
    end
end
