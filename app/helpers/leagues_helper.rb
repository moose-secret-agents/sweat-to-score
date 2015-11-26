module LeaguesHelper
  def teamable_name(teamable)
    if teamable.is_a? Partnership
      "managed with #{teamable.partner.name}"
    else
      "managed by #{teamable.name}"
    end
  end
end
