class League < ActiveRecord::Base
  has_many :teams, dependent: :destroy
  has_many :players, through: :teams
  has_many :matches

  belongs_to :owner, class_name: 'User'

  validates_inclusion_of :level, in: 1..3

  scope :overdue, -> { League.inactive.where('starts_at < ?', Time.now) }
  scope :should_finish, -> {League.active-League.active.includes(:matches).where(:matches=>{status: [Match.statuses[:running], Match.statuses[:scheduled]]})}
  enum status: { inactive: 0, active: 1 }

  def min_length
    SchedulerDoubleRR.new.min_league_length(self)
  end

  def start
    unless starts_at.nil? || pause_length.nil? || pause_length.nil?
      Match.destroy_all(:status=> Match.statuses[:scheduled],:league=>self)
      sched=SchedulerDoubleRR.new
      sched.schedule_season(self)
      active!
      update! starts_at: starts_at+sched.actual_league_length(self).days+pause_length.days
    end
  end

  def end
    Match.destroy_all(:status=> Match.statuses[:scheduled],:league=>self)
    inactive!
  end

  def schedule_match(team_a, team_b, time=1.day.from_now)
    self.matches.create(teamA: team_a, teamB: team_b, starts_at: time)
  end

end
