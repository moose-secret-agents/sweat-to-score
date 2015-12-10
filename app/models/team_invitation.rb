class TeamInvitation < ActiveRecord::Base

  belongs_to :user, class_name: 'User', foreign_key: 'user_id'
  belongs_to :invitee, class_name: 'User', foreign_key: 'invitee_id'
  belongs_to :team, class_name: 'Team', foreign_key: 'team_id'

  enum status: {proposed: 0, accepted: 1, refused: 2}

  def accept
    accepted!
  end

  def refuse
    refused!
  end

  def self.exists_for_user?(user, team)
    TeamInvitation.where(user: user, team: team).any?
  end
end