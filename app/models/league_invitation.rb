class LeagueInvitation < ActiveRecord::Base

  belongs_to :user, class_name: 'User', foreign_key: 'user_id'
  belongs_to :invitee, class_name: 'User', foreign_key: 'invitee_id'
  belongs_to :league, class_name: 'League', foreign_key: 'league_id'

  enum status: {proposed: 0, accepted: 1, refused: 2}

  def accept
    accepted!
  end

  def refuse
    refused!
  end

end