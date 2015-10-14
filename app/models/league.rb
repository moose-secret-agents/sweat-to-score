class League < ActiveRecord::Base
  has_many :teams
  has_many :players, through: :teams
  has_many :matches

  belongs_to :owner, class_name: 'User'

  validates_inclusion_of :level, in: 1..3

  def schedule_match(team_a, team_b, time=1.day.from_now)
    self.matches.create(teamA: team_a, teamB: team_b, starts_at: time)
  end
end
