module ApplicationHelper

  def get_notification_info
    team_invitations = TeamInvitation.all.where("invitee_id = ?", current_user.id)
    league_invitations = LeagueInvitation.all.where("invitee_id = ?", current_user.id)

    notifications = team_invitations.count + league_invitations.count + (current_user.remote_tokens == 0 ? 0 : 1)
  end
end
