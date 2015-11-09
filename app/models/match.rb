class Match < ActiveRecord::Base
  belongs_to :league

  belongs_to :teamA, class_name: 'Team'
  belongs_to :teamB, class_name: 'Team'

  enum status: { scheduled: 0, started: 1, ended: 2, cancelled: 3 }

  def glyphicon
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
    delta = time - Time.now
    t = %w[days hours minutes]

    t.collect do |step|
      seconds = 1.send(step)
      (delta / seconds).to_i.tap do
        delta %= seconds
      end
    end
  end
end
