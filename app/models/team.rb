class Team < ActiveRecord::Base
  DEFAULT_PLAYER_COUNT = 16

  has_many :players, dependent: :destroy
  belongs_to :league
  belongs_to :teamable, polymorphic: true

  validates_presence_of :league, :teamable, :name

  after_create :assign_players

  def averageSkill
    skill=0
    self.players.each do |player|
      skill+=[player.goalkeep, player.defense, player.midfield, player.attack].max
    end
    skill/self.players.count
  end

  def matches
    Match.where('"teamA_id" = ? or "teamB_id" = ?', id, id)
  end

  def rank_in_league
    league.teams.where('points > ?', self.points).count + 1
  end

  def assign_players
    return if players.count > 0

    ActiveRecord::Base.transaction do
      positionsX = [1,20,20,20,20,45,45,45,45,75,75,0,0,0,0,0]
      positionsY = [30,12,24,36,48,12,24,36,48,24,36,0,0,0,0,0]
      DEFAULT_PLAYER_COUNT.times.map do |i| Fabricate(:player, {team: self,fieldX: positionsX[i], fieldY: positionsY[i]}) end
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
    available_tokens = self.league.target - self.spent_tokens
    return false if tokens > available_tokens
    self.spent_tokens += tokens
    self.teamable
    factor = tokens / league.target
    self.players.each do |player|
      player.train(factor)
      player.save
    end
    true
    self.save
  end

end
