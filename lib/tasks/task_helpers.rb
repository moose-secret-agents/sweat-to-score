module TaskHelpers

  def self.start_overdue_leagues
    count = League.overdue.count
    Rails.logger.debug "Ending #{count} overdue auctions now"

    League.overdue.each do |league|
      league.start
      Rails.logger.debug "Activated #{league.name}"
    end
  end

end