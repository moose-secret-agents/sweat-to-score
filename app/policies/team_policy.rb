class TeamPolicy < ApplicationPolicy
  def edit?
    user_is_owner?
  end

  def update?
    user_is_owner?
  end

  def destroy?
    user_is_owner?
  end

  def positions?
    user_is_owner?
  end

  private
  def user_is_owner?
    if record.teamable.is_a? User
      user == record.teamable
    elsif record.teambable.is_a? Partnership
      partnership = record.teamable
      partnership.user == user || partnership.partner == user
    else
      false
    end
  end
end