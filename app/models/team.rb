class Team < ActiveRecord::Base
  has_many :players
  belongs_to :league
  belongs_to :teamable, polymorphic: true

  validates_presence_of :league, :teamable, :name

  after_create :assign_players

  def matches
    Match.where('"teamA_id" = ? or "teamB_id" = ?', id, id)
  end

  def rank_in_league
    league.teams.where('points > ?', self.points).count + 1
  end

  def assign_players
    return if players.count > 0

    ActiveRecord::Base.transaction do
      (11 + rand(14)).times do
        Fabricate(:player, team: self)
      end
    end
  end

  def destroy
    self.players.each do |player|
      player.destroy
    end
    super
  end
end
