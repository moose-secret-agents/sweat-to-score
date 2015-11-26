class Team < ActiveRecord::Base
  has_many :players, dependent: :destroy
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
      (18 + rand(7)).times do
        Fabricate(:player, team: self)
      end
    end
  end

  def to_s
    self.name
  end

  def stats(line)
    case line
      when :G then players.map(&:goalkeep).sum / players.count
      when :D then players.map(&:defense).sum / players.count
      when :M then players.map(&:midfield).sum / players.count
      when :O then players.map(&:attack).sum / players.count
      else 0
    end
  end

  def train(tokens)
    # TODO: Do something to team to increase its strenth
  end

end
