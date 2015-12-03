class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy]
  before_action :set_user, only: [:index, :new, :create]

  def index
    @user = User.find(params[:user_id])
    @own_teams = @user.teams
    @partners = Partnership.all.where("user_id = ? OR partner_id = ?", current_user.id, current_user.id)
    @partner_teams = @partners.map(&:teams).flatten
  end

  def show
    @matches = @team.matches.order(:starts_at)
  end

  def new
    @team = @user.teams.build
  end

  def edit
  end

  def create
    @team = @user.teams.create(team_params)

    if @team.save
      redirect_to @team, notice: 'Team was successfully created.'
    else
      render :new
    end
  end

  def update
    if @team.update(team_params)
      redirect_to @team, notice: 'Team was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    owner = @team.teamable
    @team.destroy
    redirect_to user_teams_url(owner), notice: 'Team was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Team.find(params[:id])
    end

    def set_user
      @user = User.find(params[:user_id])
    end

    # Only allow a trusted parameter "white list" through.
    def team_params
      params.require(:team).permit(:name, :strength, :league_id, :points)
    end
end
