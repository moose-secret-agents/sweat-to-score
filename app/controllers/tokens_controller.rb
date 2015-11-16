class TokensController < ApplicationController

  before_action :set_user, only: [:index, :book]

  def index
    # TODO: make this async, could be slow as hell
    @tokens = @user.coach_user.subscriptions.flat_map(&:entries)
  end

  def book
    @user.tokens += @user.remote_tokens

    if @user.save
      # delete remote tokens
      coach_client.authenticated(@user.username, session[:password]) do
        @user.coach_user.set_client(coach_client)
        @user.coach_user.subscriptions.flat_map(&:entries).each(&:destroy)
      end

      flash[:success] = 'Successfully added remote tokens to bank...'
    else
      flash[:error] = 'Unable to add remote tokens to bank...'
    end

    redirect_to :back
  end

  private
    def set_user
      @user = User.find(params[:user_id])
    end

end
