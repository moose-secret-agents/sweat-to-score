class TokensController < ApplicationController

  before_action :set_user, only: [:index]

  def index
    # TODO: make this async, could be slow as hell
    @tokens = @user.coach_user.subscriptions.flat_map(&:entries)
  end

  private
    def set_user
      @user = User.find(params[:user_id])
    end

end
