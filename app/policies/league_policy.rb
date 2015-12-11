class LeaguePolicy < ApplicationPolicy
  def edit?
    is_league_owner?
  end

  def update?
    is_league_owner?
  end

  def destroy?
    is_league_owner?
  end

  private
  def is_league_owner?
    user == record.owner || is_admin?
  end

  def is_admin?
    user.username == 'stsadmin'
  end
end