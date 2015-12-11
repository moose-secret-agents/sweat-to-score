class TokenPolicy
  attr_accessor :current_user, :team, :user

  def initialize(current_user, team, user)
    @current_user = current_user
    @team = team
    @user = user
  end

  def train?
    
  end

  def book?

  end

end