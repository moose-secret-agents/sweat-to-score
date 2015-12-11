class UserPolicy < ApplicationPolicy
  def update?
    user_is_current_user?
  end

  def destroy?
    user_is_current_user?
  end

  def edit?
    user_is_current_user?
  end

  private
  def user_is_current_user?
    user == record
  end
end