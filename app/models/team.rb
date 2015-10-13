class Team < ActiveRecord::Base
  has_many :players
  belongs_to :league
  belongs_to :teamable, polymorphic: true

  validates_presence_of :league, :teamable, :name

  after_create :assign_players

  def matches
    Match.where('"teamA_id" = ? or "teamB_id" = ?', id, id)
  end

  def assign_players
    ActiveRecord::Base.transaction do
      (11 + rand(14)).times do |i|
        players.create!(name: "Player #{i}", talent: rand(100))
      end
    end
  end
end
