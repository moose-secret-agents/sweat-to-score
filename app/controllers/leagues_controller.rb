class LeaguesController < ApplicationController
  before_action :set_user, only: [:index, :user_index, :new, :create]
  before_action :set_league, only: [:show, :update, :destroy, :edit, :start, :stop]

  def index
    @leagues = League.all
    @invitees = User.all.where.not(id: current_user.id)
    @invitation = @user.league_invitations.build
  end

  def new
    @league = @user.leagues.build
    @min_length=@league.min_length
    #@max_target=@league.max_target
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
	  @teams = @league.teams.sort_by(&:rank_in_league)
    @matches = @league.matches.order(:starts_at)
  end

  def update
    authorize @league

    @league.update_attribute :starts_at, params[:league][:starts_at]

    if @league.update(league_params)
      redirect_to @league, notice: 'League was successfully updated.'
    else
      render :edit
    end
  end

  def start
    authorize @league

    if @league.inactive?
      @league.start
      redirect_to @league, notice: 'League started'
    else
      flash[:error] = "League is already #{@league.status}"
      redirect_to @league
    end
  end

  def stop
    authorize @league

    if @league.active?
      @league.end
      redirect_to @league, notice: 'League ended'
    else
      flash[:error] = "League is already #{@league.status}"
      redirect_to @league
    end
  end

  def destroy
    authorize @league

    @league.destroy
    redirect_to user_leagues_path(current_user), notice: 'League was successfully destroyed.'
  end

  def user_index
    @leagues = current_user.leagues
    @invitees = User.all.where.not(id: current_user.id)
    @invitation = @user.league_invitations.build
    render :index
  end

  def edit
    authorize @league

    @min_length=@league.min_length
  end

  private
    def league_params
      params.require(:league).permit(:name, :level, :league_length, :pause_length, :starts_at, :target )
    end

    def set_user
      @user = current_user
    end

    def set_league
      @league = League.find(params[:id])
    end
end
