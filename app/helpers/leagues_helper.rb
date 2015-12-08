module LeaguesHelper
  def teamable_name(teamable)
    if teamable.is_a? Partnership
      "managed with #{([teamable.user, teamable.partner] - [current_user]).first.name}"
    else
      "managed by #{teamable.name}"
    end
  end
end
