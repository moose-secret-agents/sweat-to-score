module TaskHelpers

  def self.start_overdue_leagues
    count = League.overdue.count
    Rails.logger.debug "Starting #{count} overdue leagues now"

    League.overdue.each do |league|
      league.start
      Rails.logger.debug "Activated League: #{league.name}"
    end
  end

  def self.end_finished_leagues
    count = League.should_finish.count
    Rails.logger.debug "Ending #{count} finished leagues now"

    League.should_finish.each do |league|
      league.stop
      Rails.logger.debug "Ended League: #{league.name}"
    end
  end

end