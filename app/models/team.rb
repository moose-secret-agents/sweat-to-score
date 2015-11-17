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

  def train(tokens)
    # TODO: Do something to team to increase its strenth
  end

end
