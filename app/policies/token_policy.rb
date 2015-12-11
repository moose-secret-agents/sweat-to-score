class TokenPolicy < ApplicationPolicy

  def train?
    # record is team
    Pundit.policy!(user, record).update?
  end

  def book?
    user == record
  end

end