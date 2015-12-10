module TaskHelpers

  def self.start_overdue_leagues
    to_start = League.overdue
    count = to_start.count
    Rails.logger.debug "Starting #{count} overdue leagues now"

    to_start.each do |league|
      league.start
      Rails.logger.debug "Activated League: #{league.name}"
    end
  end

  def self.end_finished_leagues
    to_finish = League.should_finish
    count = to_finish.count
    Rails.logger.debug "Ending #{count} finished leagues now"

    to_finish.each do |league|
      league.end
      Rails.logger.debug "Ended League: #{league.name}"
    end
  end

  def self.start_overdue_matches
    to_start = Match.overdue
    count = to_start.count
    Rails.logger.debug "Starting #{count} overdue matches now"

    to_start.each do |match|
      match.simulate
      Rails.logger.debug "Started Match: #{match.teamA.name} vs #{match.teamB.name}"
    end
  end

  def self.encode_gif(path)
    Dir.chdir Rails.root.join('app','assets','Java') do
      puts `java -jar gifEncoder.jar #{path}`
    end
  end

  def self.clear_tokens
    Rails.logger.debug "Resetting token allocation"
    Team.all.each do |player|
      player.spent_tokens = 0
      player.save
    end
  end

end