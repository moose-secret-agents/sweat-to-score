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

end