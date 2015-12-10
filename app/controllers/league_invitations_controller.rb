class LeagueInvitationsController < ApplicationController

  before_action :set_user, only: [:create]
  before_action :set_invitation, only: [:destroy, :accept, :refuse]


  def create
    @invitation = @user.league_invitations.create(invitation_params)

    if @invitation.save
      redirect_to :back, notice: "Invitation request has been sent to #{@invitation.invitee.username}."
    else
      render partial: 'invitations/new_league_form'
    end
  end

  def destroy
    @invitation.destroy
  end

  def accept
    @invitation.accept
    redirect_to new_user_team_path(current_user, params:{:league_id => @invitation.league_id}),
                notice: "League invitation successfully accepted."
    destroy
  end

  def refuse
    @invitation.refuse
    destroy
    redirect_to :back, notice: "League invitation successfully REFUSED."
  end


  private
    def invitation_params
      params.require(:league_invitation).permit(:user_id, :invitee_id, :league_id, :status)
    end

    def set_user
      @user = current_user
    end

    def set_invitation
      @invitation = LeagueInvitation.find(params[:id])
    end
end