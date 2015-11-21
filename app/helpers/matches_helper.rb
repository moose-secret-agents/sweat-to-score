module MatchesHelper

  def glyphicon(status)
    case status
      when 'scheduled'
        "glyphicon-pencil"
      when 'started'
        "glyphicon-ok"
      when 'ended'
        "glyphicon-flag"
      when 'cancelled'
        "glyphicon-remove"
    end
  end


  def getTimeDifference(time)
    delta = (time - Time.now).abs

    minutes = (delta / 60) % 60
    hours = (delta / (60 * 60)) % 24
    days = (delta / (60 * 60 * 24))

    time > Time.now ? format("%dd %dh %dm", days, hours, minutes) : format("-(%dd %dh %dm)", days, hours, minutes)
  end

end