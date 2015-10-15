class LeaguesController < ApplicationController
  def index
    @leagues = League.all
  end

  def user_index
    @leagues = current_user.leagues
    render :index
  end

  def show
    @league = League.find(params[:id])
  end
end
