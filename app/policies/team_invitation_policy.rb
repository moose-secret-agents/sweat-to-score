class TeamInvitationPolicy < ApplicationPolicy
  def create?
    is_own_team?
  end

  private
  def is_own_team?
    record.user == user
  end
end