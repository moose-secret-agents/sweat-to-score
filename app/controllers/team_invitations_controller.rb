class TeamInvitationsController < ApplicationController

  before_action :set_user, only: [:create]
  before_action :set_invitation, only: [:destroy, :accept, :refuse]


  def create
    @invitation = @user.team_invitations.create(invitation_params)

    if @invitation.save
      redirect_to :back, notice: "Invitation request has been sent to #{@invitation.invitee.username}."
    else
      render partial: 'invitations/new_team_form'
    end
  end

  def destroy
    @invitation.destroy
  end

  def accept
    @invitation.accept
    Partnership.create(:user_id => @invitation.user_id, :partner_id => @invitation.invitee_id, :status => 1)
    redirect_to user_partnerships_path(current_user),
                notice: "Team invitation successfully accepted. You are now Partner of #{@invitation.user.username}."
    destroy
  end

  def refuse
    @invitation.refuse
    destroy
    redirect_to :back, notice: "Team invitation successfully REFUSED."
  end


  private
    def invitation_params
      params.require(:team_invitation).permit(:user_id, :invitee_id, :team_id, :status)
    end

    def set_user
      @user = current_user
    end

    def set_invitation
      @invitation = TeamInvitation.find(params[:id])
    end
end